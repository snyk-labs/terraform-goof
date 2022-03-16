data "aws_iam_policy_document" "admin-assume-role-policy" {
  statement {
    actions = ["*"]
    resources = ["*"]
  }
}

resource "aws_iam_role" "snyk-admin-role" {
  name                = "snyk_${var.environment}_role"
  assume_role_policy  = data.aws_iam_policy_document.admin-assume-role-policy.json # (not shown)
  managed_policy_arns = []
}
