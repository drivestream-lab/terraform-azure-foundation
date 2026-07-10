# terraform-azure-foundation

**Cookiecutter chassis for Azure Terraform stacks** — pairs with
[terraform-infra-rules](../terraform-infra-rules). The scaffold is an
**accelerator, not a product decision**: it emits a uniform, day-one-green project
shape and a verifiable answer to *"is my setup fine?"* — it does **not** choose
product data-plane components. Those arrive per stack via spec → ADR as the
project progresses.

| | |
|---|---|
| **License** | [MIT](LICENSE) |
| **Template engine** | Cookiecutter |
| **Version** | see [`VERSION`](VERSION) (currently **0.1.2**) · [CHANGELOG](CHANGELOG.md) |
| **Pairs with** | terraform-infra-rules |
| **Sibling (planned)** | terraform-aws-foundation — same shape, AWS-native content |

## Options

| Option | Meaning |
|---|---|
| `stack_name`, `client`, `org_prefix` | Identity → naming/tagging seeds |
| `location` | Azure region |
| `subscription_strategy` | `per-env` or `single` |
| `environments` | Comma list; one thin root generated per env |
| `ci_platform` | `github` (OIDC plan/apply workflows) or `none` |
| `github_org` | GitHub org for OIDC federation subjects in bootstrap |

Deliberately absent: `has_*` component flags and harness files (`AGENTS.md`,
`.harness-pin.yaml`, `.gitmodules`). Wire the rules submodule and agent harness
separately when using launchpad.

## What the chassis guarantees

1. **Shape** — identical structure across every client stack (`envs/`, substrate
   `modules/`, empty `docs/specification/`, `docs/setup/`, Makefile verbs).
2. **Setup verification** — `bootstrap/` (once-per-client state + OIDC identities),
   `preflight`, and a data-source-only `whoami` plan as the end-to-end proof.
3. **Substrate module contracts** — network, k8s, secrets, storage, observability,
   postgres, redis (README stubs only; wired when your team adds modules).
4. **Guardrails wired** — plan-only CI credentials, gated apply workflow, policy
   gate hook (conftest against rules-repo policies when submodule is present).

`docs/specification/` is **empty** in the scaffold — populate via harness. Tool install
guides ship in `docs/setup/`.

## Usage

```bash
pip install cookiecutter
cookiecutter /path/to/terraform-azure-foundation --checkout v0.1.2
```

The post-gen hook expands one root per environment, derives state storage account
names (validated ≤24 chars), injects env lists into bootstrap + workflows, and
prints the day-one runbook.

## AWS port conformance

terraform-aws-foundation must keep: option names, directory shape, Makefile verbs,
the three-stage setup contract, ADR/spec layout, and uniform module output names —
only provider-level content (bootstrap resources, backend, identities, module
internals) differs.

## SSOT

Scaffold fixes happen **here** — consumer stack repos pin a foundation release tag;
do not patch harness or constitution files downstream by hand.

---

## License

MIT — see [LICENSE](LICENSE).
