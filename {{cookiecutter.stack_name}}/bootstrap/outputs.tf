output "state_storage_accounts" {
  description = "Per-env state storage account names — must match envs/<env>/backend.tf."
  value       = { for env, sa in azurerm_storage_account.tfstate : env => sa.name }
}

output "ci_client_ids" {
  description = "Per-identity client ids. Set as GitHub environment variables: AZURE_PLAN_CLIENT_ID / AZURE_APPLY_CLIENT_ID per environment."
  value       = { for k, app in azuread_application.ci : k => app.client_id }
}

output "tenant_id" {
  description = "Set as GitHub repo variable AZURE_TENANT_ID."
  value       = data.azurerm_subscription.current.tenant_id
}

output "subscription_id" {
  description = "Set as GitHub environment variable AZURE_SUBSCRIPTION_ID."
  value       = var.subscription_id
}

output "github_setup" {
  description = "Checklist: wire these into GitHub before the first PR."
  value       = <<-EOT
    Per GitHub *environment* (Settings → Environments → <env>):
      AZURE_PLAN_CLIENT_ID   = ci_client_ids["<env>-plan"]
      AZURE_APPLY_CLIENT_ID  = ci_client_ids["<env>-apply"]
      AZURE_SUBSCRIPTION_ID  = subscription id for <env>
      + required reviewers on stage/prod (gated apply)
    Repo-level variable:
      AZURE_TENANT_ID
  EOT
}
