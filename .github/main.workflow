workflow "Run tests" {
  on = "push"
  resolves = ["Shellcheck", "Bats", "Dockerfilelint"]
}

action "Shellcheck" {
  uses = "actions/bin/shellcheck@master"
  args = "entrypoint.sh"
}

action "Bats" {
  uses = "actions/bin/bats@master"
  args = "test/*.bats"
}

action "Dockerfilelint" {
  uses = "docker://replicated/dockerfilelint"
  args = ["Dockerfile"]
}
