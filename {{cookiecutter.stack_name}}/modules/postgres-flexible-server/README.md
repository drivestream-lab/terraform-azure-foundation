# modules/postgres-flexible-server — NOT IMPLEMENTED (seeded contract)

**Status:** contract only. Implementing and wiring this module into an env requires
an accepted ADR (infra-adr.mdc) in the same PR. Anatomy per module-structure.mdc.

## Purpose
Azure Database for PostgreSQL Flexible Server — managed Postgres with zone-redundant HA option, private access only.

## Flavors
managed (only)

## Contract
- Inputs: `size_profile` (s|m|l|xl — size maps live INSIDE this module), network
  inputs from virtual-network outputs, `tags` (mandatory set, naming-tagging.mdc)
- Outputs (uniform names): `server_id`, `fqdn`, `principal_id`, `admin_secret_ref` (Key Vault reference — never the password)
- Tests: `tests/*.tftest.hcl` with mocked azurerm — every flavor plans, every size resolves
