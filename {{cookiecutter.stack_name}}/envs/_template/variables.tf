variable "subscription_id" {
  type        = string
  description = "Azure subscription for the __ENV__ environment. Set in terraform.tfvars."
  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.subscription_id))
    error_message = "subscription_id must be a GUID — run `make preflight ENV=__ENV__` to diagnose setup."
  }
}

variable "owner" {
  type        = string
  description = "Owning team, used in mandatory tags (incident routing)."
}

variable "cost_center" {
  type        = string
  description = "Cost center code, used in mandatory tags (finance attribution)."
}
