#!/usr/bin/env python3
"""Post-generation hook: expand envs/_template per environment, wire names, drop unselected CI."""

import os
import re
import shutil
import stat
import subprocess

STACK_NAME = "{{ cookiecutter.stack_name }}"
ORG_PREFIX = "{{ cookiecutter.org_prefix }}"
CLIENT = "{{ cookiecutter.client }}"
CI_PLATFORM = "{{ cookiecutter.ci_platform }}"
ENVIRONMENTS = [e.strip() for e in "{{ cookiecutter.environments }}".split(",") if e.strip()]


def state_sa_name(env: str) -> str:
    """Storage account: <=24 chars, lowercase alphanumeric (azure.mdc §6)."""
    raw = re.sub(r"[^a-z0-9]", "", f"{ORG_PREFIX}{CLIENT}tfstate{env}".lower())
    if len(raw) > 24:
        raise SystemExit(
            f"ERROR: state storage account name '{raw}' exceeds 24 chars — "
            "shorten org_prefix/client, or adjust naming in bootstrap + backend.tf together."
        )
    return raw


def render(path: str, env: str) -> None:
    with open(path) as f:
        content = f.read()
    content = content.replace("__ENV__", env).replace("__STATE_SA__", state_sa_name(env))
    with open(path, "w") as f:
        f.write(content)


# ── expand envs/_template into one root per environment ──────────────────────
template_dir = os.path.join("envs", "_template")
for env in ENVIRONMENTS:
    env_dir = os.path.join("envs", env)
    shutil.copytree(template_dir, env_dir)
    for fname in os.listdir(env_dir):
        render(os.path.join(env_dir, fname), env)
shutil.rmtree(template_dir)

# ── env list into bootstrap example + workflows ───────────────────────────────
def substitute(path: str, needle: str, value: str) -> None:
    if not os.path.isfile(path):
        return
    with open(path) as f:
        content = f.read()
    with open(path, "w") as f:
        f.write(content.replace(needle, value))


substitute(os.path.join("bootstrap", "terraform.tfvars.example"),
           '"__ENV_LIST__"', ", ".join(f'"{e}"' for e in ENVIRONMENTS))
for wf in ("plan.yml", "apply.yml"):
    substitute(os.path.join(".github", "workflows", wf),
               "__ENV_LIST_YAML__", ", ".join(ENVIRONMENTS))

# ── unselected CI platform ────────────────────────────────────────────────────
if CI_PLATFORM == "none":
    shutil.rmtree(".github", ignore_errors=True)

# ── permissions + formatting (analogue of the black step) ─────────────────────
pf = os.path.join("scripts", "preflight.sh")
os.chmod(pf, os.stat(pf).st_mode | stat.S_IEXEC | stat.S_IXGRP | stat.S_IXOTH)

terraform = shutil.which("terraform")
if terraform:
    subprocess.run([terraform, "fmt", "-recursive"], check=False)
else:
    print("Note: terraform not on PATH — run `terraform fmt -recursive` before `make check`.")

# ── report ────────────────────────────────────────────────────────────────────
print(f"""
✓ {STACK_NAME} chassis generated ({", ".join(ENVIRONMENTS)}).

Next steps:
  cd {STACK_NAME}
  make check                        # green immediately — offline, no credentials

  # once per client, by a subscription Owner:
  cd bootstrap && cp terraform.tfvars.example terraform.tfvars  # fill values
  terraform init && terraform apply && terraform output github_setup

  # then answer THE question — is my setup fine?
  make preflight ENV={ENVIRONMENTS[0]}
  make plan ENV={ENVIRONMENTS[0]}   # whoami plan succeeds = chassis proven live

Components arrive via spec → ADR as the project progresses. See `modules/README.md`
for seeded substrate contracts; wiring one into an env requires its accepted ADR.
""")
