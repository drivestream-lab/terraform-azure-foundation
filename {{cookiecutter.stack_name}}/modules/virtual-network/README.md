# modules/virtual-network — NOT IMPLEMENTED (seeded contract)

**Status:** contract only. Implementing and wiring this module into an env requires
an accepted ADR (infra-adr.mdc) in the same PR. Anatomy per module-structure.mdc.

## Purpose
VNet, subnets, NSGs, private DNS links — the network substrate; almost always the first module implemented.

## Flavors
single (no flavor variable)

## Contract
- Inputs: `size_profile` (s|m|l|xl — size maps live INSIDE this module), network
  inputs from virtual-network outputs, `tags` (mandatory set, naming-tagging.mdc)
- Outputs (uniform names): `vnet_id`, `subnet_ids` (map), `private_dns_zone_ids`
- Tests: `tests/*.tftest.hcl` with mocked azurerm — every flavor plans, every size resolves
