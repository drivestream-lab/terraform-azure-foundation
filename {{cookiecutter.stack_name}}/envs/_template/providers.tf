provider "azurerm" {
  features {}
  # Explicit — never inherited from the ambient CLI login (azure.mdc §4).
  subscription_id = var.subscription_id
}
