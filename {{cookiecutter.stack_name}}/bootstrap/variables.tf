variable "subscription_id" {
  type        = string
  description = "Subscription to bootstrap. With subscription_strategy=per-env, run bootstrap once per subscription."
  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.subscription_id))
    error_message = "subscription_id must be a GUID."
  }
}

variable "environments" {
  type        = list(string)
  description = "Environments to provision state storage and CI identities for."
  validation {
    condition     = length(var.environments) > 0
    error_message = "At least one environment required."
  }
}

variable "location" {
  type        = string
  description = "Azure region for state storage."
  default     = "{{ cookiecutter.location }}"
}

variable "owner" {
  type        = string
  description = "Owning team (mandatory tag)."
}

variable "cost_center" {
  type        = string
  description = "Cost center code (mandatory tag)."
}
