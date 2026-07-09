# Single place names and tags are built (naming-tagging.mdc §2).
locals {
  environment = "__ENV__"
  name_prefix = "{{ cookiecutter.org_prefix }}-{{ cookiecutter.client }}-__ENV__"

  tags = {
    environment = "__ENV__"
    project     = "{{ cookiecutter.stack_name }}"
    client      = "{{ cookiecutter.client }}"
    owner       = var.owner
    cost_center = var.cost_center
    managed_by  = "terraform"
    stack       = "envs/__ENV__"
  }
}
