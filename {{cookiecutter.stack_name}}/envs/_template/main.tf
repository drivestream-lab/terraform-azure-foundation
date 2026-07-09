# ── Hello world: authorization proof, not a resource ─────────────────────────
# A successful `terraform plan` here proves end-to-end: state backend reachable,
# identity authenticates, RBAC resolves, provider initializes — zero resources at stake.
#
# Components are added below as module calls ONLY (stack-architecture.mdc §1),
# each in the same PR as its accepted ADR (infra-adr.mdc §2).

data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

output "whoami" {
  description = "Proof of a working chassis: who Terraform runs as, and where."
  value = {
    identity_object_id = data.azurerm_client_config.current.object_id
    tenant_id          = data.azurerm_client_config.current.tenant_id
    subscription       = data.azurerm_subscription.current.display_name
    environment        = local.environment
    name_prefix        = local.name_prefix
  }
}
