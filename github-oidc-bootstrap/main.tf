data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}

data "aws_iam_policy_document" "github_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_repository_username}*/${var.github_repository_name}*:*"]
    }
  }
}

resource "aws_iam_role" "github_oidc" {
  name               = var.github_oidc_role_name
  assume_role_policy = data.aws_iam_policy_document.github_trust.json
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryPowerUser" {
  role       = aws_iam_role.github_oidc.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

variable "github_repository_username" {
  description = "GitHub repository username"
  type        = string
  default     = "peh3"
}

variable "github_repository_name" {
  description = "GitHub repository name"
  type        = string
  default     = "gh-activity-3.4"
}

variable "github_oidc_role_name" {
  description = "Name of the GitHub OIDC role"
  type        = string
  default     = "tk-tf-gh-activity-3.4-github-oidc-role"
}

output "github_oidc_role_arn" {
  value = aws_iam_role.github_oidc.arn
}