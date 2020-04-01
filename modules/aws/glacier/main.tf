data "aws_caller_identity" "current" {}

resource "aws_glacier_vault" "main" {
  name = "sadcloud_public_vault"
  count = var.glacier_public ? 1 : 0

  access_policy = <<EOF
{
    "Version":"2012-10-17",
    "Statement":[
       {
          "Sid": "public",
          "Principal": "*",
          "Effect": "Allow",
          "Action": "glacier:*",
          "Resource": "arn:aws:glacier:us-east-1:${data.aws_caller_identity.current.account_id}:vaults/sadcloud_public_vault"
       }
    ]
}
EOF
}
