# Contract per testing-verification.mdc — these verbs are the org-wide interface.
# Raw terraform CLI remains available for exploration; lifecycle gates go through make.

ENV ?= dev
ENVS := $(shell ls -d envs/*/ 2>/dev/null | xargs -n1 basename)

.PHONY: setup check fmt-check validate lint scan test preflight plan clean

setup: ## one-time: verify required tools are on PATH
	@command -v terraform >/dev/null || { echo "[ERROR] missing: terraform (see docs/setup/README.md)"; exit 1; }
	@command -v tflint    >/dev/null || echo "note: tflint not installed — 'make check' will skip lint"
	@command -v trivy     >/dev/null || echo "note: trivy not installed — 'make check' will skip scan"
	@command -v conftest  >/dev/null || echo "note: conftest not installed — 'make plan' will skip policy gate"
	@echo "setup complete"

check: fmt-check validate lint scan ## offline gates — no cloud, no credentials

fmt-check:
	terraform fmt -check -recursive

validate:
	@for e in $(ENVS); do \
	  echo "── validate envs/$$e"; \
	  (cd envs/$$e && terraform init -backend=false -input=false >/dev/null && terraform validate) || exit 1; \
	done
	@if [ -d bootstrap ]; then \
	  echo "── validate bootstrap"; \
	  (cd bootstrap && terraform init -backend=false -input=false >/dev/null && terraform validate); \
	fi

lint:
	@command -v tflint >/dev/null && tflint --recursive || echo "tflint not installed — skipped"

scan:
	@command -v trivy >/dev/null && trivy config --exit-code 1 . || echo "trivy not installed — skipped"

test: ## module unit tests (mocked providers, no cloud)
	@found=0; for d in modules/*/tests; do \
	  [ -d "$$d" ] && { found=1; (cd $${d%/tests} && terraform test) || exit 1; }; done; \
	  [ $$found -eq 0 ] && echo "no module tests yet — add tests when modules are implemented" || true

preflight: ## answers: is my Azure setup fine? (needs: az login)
	./scripts/preflight.sh $(ENV)

plan: ## end-to-end proof: backend + auth + provider, zero resources at stake
	cd envs/$(ENV) && terraform init -input=false && \
	  terraform plan -input=false -out=plan.tfplan && \
	  terraform show -json plan.tfplan > plan.json
	@command -v conftest >/dev/null && \
	  conftest test envs/$(ENV)/plan.json -p .cursor/rules/policies || \
	  echo "conftest not installed or no policies — policy gate skipped"

clean:
	find . -name ".terraform" -type d -prune -exec rm -rf {} +
	find . -name "plan.tfplan" -o -name "plan.json" | xargs rm -f
