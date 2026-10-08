# TFLint root config for this portfolio lab.
# WHY disable terraform_unused_declarations: modules declare `project`/`environment`
# for a consistent interface across envs (week1..full pass them), while actual
# tagging flows through the `tags` map. Flagging them adds noise without signal.
config {
  call_module_type = "local"
}

rule "terraform_unused_declarations" {
  enabled = false
}
