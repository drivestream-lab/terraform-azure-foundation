# modules/aks — NOT IMPLEMENTED (seeded contract)

**Status:** contract only. Implementing and wiring this module into an env requires
an accepted ADR (infra-adr.mdc) in the same PR. Anatomy per module-structure.mdc.

## Purpose
AKS cluster — the Kubernetes substrate for aks-flavored components. Workload identity enabled, RBAC-integrated, private API server by default.

## Flavors
single; node pools sized via size_profile

## Contract
- Inputs: `size_profile` (s|m|l|xl — size maps live INSIDE this module), network
  inputs from virtual-network outputs, `tags` (mandatory set, naming-tagging.mdc)
- Outputs (uniform names): `cluster_id`, `oidc_issuer_url`, `kubelet_identity_principal_id`, `node_resource_group`
- Tests: `tests/*.tftest.hcl` with mocked azurerm — every flavor plans, every size resolves
