# Infrastructure Specification — {{ cookiecutter.stack_name }}

The source of truth for **what must exist** (spec-driven-infra.mdc). Code is derived.

A complete spec contains:

1. **Component list with per-environment matrix** — component, flavor, size_profile,
   count per env. Incomplete matrix = don't start coding.
2. **Network topology** — VNets, CIDR plan, subnets, private endpoints, anything public.
3. **Data classification per store** — drives encryption/access decisions.
4. **SLOs affecting infra** — RTO/RPO, zone/region redundancy.
5. **Cost ceiling per environment.**

Start from `topology.md` (create it here). Decisions with alternatives go to
`../adr/`; live status is tracked in `../as-built/`.
