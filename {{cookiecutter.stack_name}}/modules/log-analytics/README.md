# modules/log-analytics — NOT IMPLEMENTED (seeded contract)

**Status:** contract only. Implementing and wiring this module into an env requires
an accepted ADR (infra-adr.mdc) in the same PR. Anatomy per module-structure.mdc.

## Purpose
Log Analytics workspace + diagnostic settings wiring — observability substrate; every other module sends diagnostics here.

## Flavors
single

## Contract
- Inputs: `size_profile` (s|m|l|xl — size maps live INSIDE this module), network
  inputs from virtual-network outputs, `tags` (mandatory set, naming-tagging.mdc)
- Outputs (uniform names): `workspace_id`, `workspace_customer_id`
- Tests: `tests/*.tftest.hcl` with mocked azurerm — every flavor plans, every size resolves
