# modules/azure-cache-redis — NOT IMPLEMENTED (seeded contract)

**Status:** contract only. Implementing and wiring this module into an env requires
an accepted ADR (infra-adr.mdc) in the same PR. Anatomy per module-structure.mdc.

## Purpose
Azure Cache for Redis — managed Redis, private endpoint, TLS-only.

## Flavors
managed (only)

## Contract
- Inputs: `size_profile` (s|m|l|xl — size maps live INSIDE this module), network
  inputs from virtual-network outputs, `tags` (mandatory set, naming-tagging.mdc)
- Outputs (uniform names): `cache_id`, `hostname`, `principal_id`, `access_secret_ref`
- Tests: `tests/*.tftest.hcl` with mocked azurerm — every flavor plans, every size resolves
