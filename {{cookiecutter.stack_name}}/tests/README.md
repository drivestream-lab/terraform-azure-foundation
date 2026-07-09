# tests/

Module unit tests live **inside each module** (`modules/<name>/tests/*.tftest.hcl`,
mocked providers — `make test` discovers them). See testing-verification.mdc.

This directory holds `verify/` — live verification scripts against a sandbox
subscription. Manual trigger only; never in CI, never against shared environments.
