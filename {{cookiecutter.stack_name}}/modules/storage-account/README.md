# modules/storage-account — NOT IMPLEMENTED (seeded contract)

**Status:** contract only. Implementing and wiring this module into an env requires
an accepted ADR (infra-adr.mdc) in the same PR. Anatomy per module-structure.mdc.

## Purpose
Storage account — RBAC-only auth, versioning, public access blocked, name normalized internally (<=24 chars, azure.mdc §6).

## Flavors
single

## Contract
- Inputs: `size_profile` (s|m|l|xl — size maps live INSIDE this module), network
  inputs from virtual-network outputs, `tags` (mandatory set, naming-tagging.mdc)
- Outputs (uniform names): `account_id`, `primary_blob_endpoint`, `principal_id`
- Tests: `tests/*.tftest.hcl` with mocked azurerm — every flavor plans, every size resolves
