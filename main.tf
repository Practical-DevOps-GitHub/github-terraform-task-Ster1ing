provider "github" {
  token = "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"
  owner = "Practical-DevOps-GitHub"
}

resource "github_repository" "example" {
  name        = "github-terraform-task-Ster1ing"
  description = "github-terraform-task-Ster1ing created by GitHub Classroom"
  template {
    include_all_branches = false
    owner                = "Practical-DevOps-GitHub"
    repository           = "github-terraform-task"
  }
  has_downloads = true
  has_issues    = true
  has_projects  = true
  has_wiki      = true
}

resource "github_branch" "develop" {
  repository = github_repository.example.name
  branch     = "develop"
}

resource "github_branch_default" "default" {
  repository = github_repository.example.name
  branch     = github_branch.develop.branch
}

resource "github_repository_collaborator" "a_repo_collaborator" {
  repository = github_repository.example.name
  username   = "softservedata"
  permission = "admin"
}

resource "github_branch_protection" "main" {
  repository_id = github_repository.example.name
  pattern       = "main"
  required_pull_request_reviews {
    require_code_owner_reviews      = true
    required_approving_review_count = 0
  }
}

resource "github_repository_file" "codeowners" {
  repository          = github_repository.example.name
  branch              = "main"
  file                = ".github/CODEOWNERS"
  content             = "* @softservedata"
  commit_message      = "- added CODEOWNERS file"
  overwrite_on_create = true
}

variable "pull_request_template_content" {
  type = string
  default = <<-EOT
## Describe your changes

## Issue ticket number and link

## Checklist before requesting a review
- [ ] I have performed a self-review of my code
- [ ] If it is a core feature, I have added thorough tests
- [ ] Do we need to implement analytics?
- [ ] Will this be part of a product update? If yes, please write one phrase about this update
EOT
}

resource "github_repository_file" "pull_request_template_main" {
  repository = github_repository.example.name
  branch     = "main"
  file       = ".github/pull_request_template.md"
  commit_message      = "- added pull_request_template.md file"
  overwrite_on_create = true
  content    = var.pull_request_template_content
}

resource "github_repository_file" "pull_request_template_develop" {
  repository = github_repository.example.name
  branch     = "develop"
  file       = ".github/pull_request_template.md"
  commit_message      = "- added pull_request_template.md file"
  overwrite_on_create = true
  content    = var.pull_request_template_content
}

resource "github_branch_protection" "develop" {
  repository_id = github_repository.example.name
  pattern       = "develop"
  required_pull_request_reviews {
    required_approving_review_count = 2
  }
}

resource "github_repository_deploy_key" "example_repository_deploy_key" {
  title      = "DEPLOY_KEY"
  repository = github_repository.example.name
  key        = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC9FOdITthPctHg9bmYxEZmg/1wkG0+N1xBx/E1UkU/C/tqL7NREGkL/kxQ1Zmcx/N6Kd1iDIAjQFKnLREID36xH8YaJM0rTFt4EH2M8Em/VODPflrRZ+uLItCx/JTUVMCD3pG1KV9u43Jqg0ixDnNlUePSu3EBM5mBUR0BjAP2c9IcB4fLcgTK+1uJDQySvOC+2DeyPY5lw3yx5sbKYe/FqMF23uk7YDq2WzeJTtswOHFwNTW5OWeJh2yTpUmOAEWhSi+YV2BN/IEvv5FC8zmKgutcTBnnChvxZbkFTiOxMqD/aGISN3+ioiSRi1WuQTi+WaHRp44+k3Bo51Y1OqoF4l3RsNqbc40ef0IS9QmSfccA8SzedqVIYUjWJAvvTIWKti9flHdbYmTIC5/zkeqdap5aWnIH/1WoCWhEvY4dNTOKs++sZfgVCLQ4e9qgBpzhBNf0r1q/qQL3UeiiQ2TX4uIXu1JlHoVm3Y+CzftyDvTSnN7ZdH4TFTbZD5EnBOs= otarakanov@otarakanov-5411"
  read_only  = "true"
}

resource "github_repository_webhook" "webhook" {
  repository = github_repository.example.name
  configuration {
    url          = "https://discord.com/api/webhooks/1159081529234968647/x5nXMVYaXg7wOOY294v2QPZlSEh5euAYW2_trzlvnPWdjjYhANLArEyf--hgGxWG_N2w/github"
    content_type = "json"
    insecure_ssl = false
  }
  active = true
  events = ["pull_request", "pull_request_review_comment", "pull_request_review", "pull_request_review_thread", "push"]
}

resource "github_actions_secret" "example_secret" {
  repository      = github_repository.example.name
  secret_name     = "PAT"
  plaintext_value = "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"
}
