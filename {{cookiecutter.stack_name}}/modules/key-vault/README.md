# modules/key-vault — NOT IMPLEMENTED (seeded contract)

**Status:** contract only. Implementing and wiring this module into an env requires
an accepted ADR (infra-adr.mdc) in the same PR. Anatomy per module-structure.mdc.

## Purpose
Key Vault — RBAC-authorized (no access policies), purge protection on, private endpoint. The secret_ref target for every other module.

## Flavors
single

## Contract
- Inputs: `size_profile` (s|m|l|xl — size maps live INSIDE this module), network
  inputs from virtual-network outputs, `tags` (mandatory set, naming-tagging.mdc)
- Outputs (uniform names): `vault_id`, `vault_uri`
- Tests: `tests/*.tftest.hcl` with mocked azurerm — every flavor plans, every size resolves
