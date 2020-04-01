resource "aws_config_configuration_recorder" "main" {
  name     = var.name
  role_arn = aws_iam_role.config_role[0].arn

  count = var.config_recorder_not_configured ? 1 : 0
}

resource "aws_iam_role" "config_role" {
  name = "awsconfig-example-role"

  count = var.config_recorder_not_configured ? 1 : 0

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}
