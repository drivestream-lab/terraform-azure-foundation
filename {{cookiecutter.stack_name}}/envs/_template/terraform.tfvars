# Per-environment decisions live HERE — values only, no logic
# (environments-and-promotion.mdc). Every value should trace to a spec line or ADR.

subscription_id = "00000000-0000-0000-0000-000000000000" # TODO: set real value; preflight verifies
owner           = "platform-team"
cost_center     = "cc-0000" # TODO

# Component decisions land below via accepted ADRs, e.g.:
# postgres_flexible_server = { size_profile = "s", ... }
