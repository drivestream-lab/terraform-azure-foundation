# State backend for the __ENV__ environment.
# Storage account is created by bootstrap/ (run once by an Owner) — names must match.
# Locking is blob-lease (built into the azurerm backend). Auth via Entra RBAC, not access keys.
terraform {
  backend "azurerm" {
    resource_group_name  = "{{ cookiecutter.org_prefix }}-{{ cookiecutter.client }}-tfstate"
    storage_account_name = "__STATE_SA__"
    container_name       = "tfstate"
    key                  = "{{ cookiecutter.stack_name }}.tfstate"
    use_azuread_auth     = true
  }
}
