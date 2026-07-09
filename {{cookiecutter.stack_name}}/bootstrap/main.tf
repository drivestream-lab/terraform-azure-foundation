# ── Bootstrap: the one-time, human-run foundation ────────────────────────────
# Solves the chicken-and-egg: state storage and CI identities cannot be managed
# by the Terraform they enable. Run ONCE per client by a subscription Owner:
#
#   cd bootstrap
#   cp terraform.tfvars.example terraform.tfvars   # fill values
#   terraform init && terraform apply              # documented never-apply exception
#
# Local state is committed on purpose — it contains only ids/names, no secrets.

terraform {
  required_version = "~> 1.9.0"
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 4.14" }
    azuread = { source = "hashicorp/azuread", version = "~> 3.0" }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

provider "azuread" {}

locals {
  environments = toset(var.environments)
  # Storage account names: ≤24 chars, lowercase alphanumeric (azure.mdc §6)
  sa_names = {
    for env in local.environments :
    env => substr(replace(lower("{{ cookiecutter.org_prefix }}{{ cookiecutter.client }}tfstate${env}"), "/[^a-z0-9]/", ""), 0, 24)
  }
  # CI role kinds and the federation subject each one trusts
  ci_identities = merge([
    for env in local.environments : {
      "${env}-plan" = {
        env     = env
        role    = "plan"
        subject = "repo:{{ cookiecutter.github_org }}/{{ cookiecutter.stack_name }}:pull_request"
      }
      "${env}-apply" = {
        env     = env
        role    = "apply"
        subject = "repo:{{ cookiecutter.github_org }}/{{ cookiecutter.stack_name }}:environment:${env}"
      }
    }
  ]...)

  tags = {
    environment = "shared"
    project     = "{{ cookiecutter.stack_name }}"
    client      = "{{ cookiecutter.client }}"
    owner       = var.owner
    cost_center = var.cost_center
    managed_by  = "terraform-bootstrap"
    stack       = "bootstrap"
  }
}

# ── State storage ─────────────────────────────────────────────────────────────

resource "azurerm_resource_group" "tfstate" {
  name     = "{{ cookiecutter.org_prefix }}-{{ cookiecutter.client }}-tfstate"
  location = var.location
  tags     = local.tags
}

resource "azurerm_storage_account" "tfstate" {
  for_each = local.environments

  name                            = local.sa_names[each.key]
  resource_group_name             = azurerm_resource_group.tfstate.name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "GRS"
  min_tls_version                 = "TLS1_2"
  shared_access_key_enabled       = false # RBAC only (azure.mdc §3)
  allow_nested_items_to_be_public = false

  blob_properties {
    versioning_enabled = true
    delete_retention_policy { days = 30 }
    container_delete_retention_policy { days = 30 }
  }

  tags = merge(local.tags, { environment = each.key })

  lifecycle { prevent_destroy = true }
}

resource "azurerm_storage_container" "tfstate" {
  for_each = local.environments

  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.tfstate[each.key].id
  container_access_type = "private"
}

# ── CI identities: plan (read) + apply (write) per environment ───────────────

resource "azuread_application" "ci" {
  for_each     = local.ci_identities
  display_name = "{{ cookiecutter.org_prefix }}-{{ cookiecutter.client }}-ci-${each.key}"
}

resource "azuread_service_principal" "ci" {
  for_each  = local.ci_identities
  client_id = azuread_application.ci[each.key].client_id
}

# GitHub OIDC federation — no secrets stored anywhere (azure.mdc §1)
resource "azuread_application_federated_identity_credential" "ci" {
  for_each = local.ci_identities

  application_id = azuread_application.ci[each.key].id
  display_name   = "github-${each.key}"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = each.value.subject
}

# ── RBAC (plan-apply-workflow.mdc: plan credentials cannot write) ─────────────

data "azurerm_subscription" "current" {}

resource "azurerm_role_assignment" "subscription" {
  for_each = local.ci_identities

  scope                = data.azurerm_subscription.current.id
  role_definition_name = each.value.role == "plan" ? "Reader" : "Contributor"
  principal_id         = azuread_service_principal.ci[each.key].object_id
}

# Both roles need blob write on their env's state (blob-lease locking writes a lease).
resource "azurerm_role_assignment" "state" {
  for_each = local.ci_identities

  scope                = azurerm_storage_account.tfstate[each.value.env].id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azuread_service_principal.ci[each.key].object_id
}
