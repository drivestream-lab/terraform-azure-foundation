# Changelog

All notable changes to `terraform-azure-foundation` are documented here.

---

## v0.1.1

### Summary

Align with python-fastapi-foundation / nextjs-bff-foundation boundary — harness
out of scaffold, substrate-only module catalog.

### Changes

- **Removed** harness files from template: `AGENTS.md`, `.harness-pin.yaml`, `.gitmodules`
- **Removed** `rules_version` cookiecutter prompt
- **`make setup`** — tool checks only; no launchpad/submodule wiring
- **Removed** product data-plane module seeds: `kafka`, `clickhouse`, `cratedb`
- **`modules/README.md`** — substrate catalog + explicit ADR-gated growth model
- Added `VERSION` and `CHANGELOG.md`

### Migration guide

- Regenerate from v0.1.1+ or copy updated files into existing stacks
- Wire `.cursor/rules/` submodule and harness via launchpad separately

---

## v0.1.0

### Summary

Initial Azure Terraform cookiecutter chassis (pre-boundary-cleanup baseline).
