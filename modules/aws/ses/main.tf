resource "aws_ses_domain_identity" "main" {
  domain = "example.com"
}

resource "aws_ses_domain_dkim" "main" {
  domain = aws_ses_domain_identity.main.domain

  count = var.no_dkim_enabled ? 0 : 1
}

data "aws_iam_policy_document" "main" {
  statement {
    actions   = ["SES:SendEmail", "SES:SendRawEmail"]
    resources = [aws_ses_domain_identity.main.arn]

    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
  }
}

resource "aws_ses_identity_policy" "main" {
  name     = var.name
  identity = aws_ses_domain_identity.main.arn
  policy   = data.aws_iam_policy_document.main.json

  count    = var.identity_world_policy ? 1 : 0
}
