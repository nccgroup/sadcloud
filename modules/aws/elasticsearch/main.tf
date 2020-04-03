resource "aws_elasticsearch_domain" "main" {
  count = var.elasticsearch_logging_disabled || var.elasticsearch_open_access ? 1 : 0

  domain_name           = var.name
  elasticsearch_version = "6.0"

  cluster_config {
    instance_type = "t2.small.elasticsearch"
  }

  ebs_options {
    ebs_enabled = true
    volume_type = "gp2"
    volume_size = 10
  }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.main.arn
    log_type                 = "INDEX_SLOW_LOGS"
    enabled = !var.elasticsearch_logging_disabled
  }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.main.arn
    log_type                 = "SEARCH_SLOW_LOGS"
    enabled = !var.elasticsearch_logging_disabled
  }

  depends_on = [
    aws_cloudwatch_log_group.main
  ]
}

resource "aws_cloudwatch_log_group" "main" {

  name = var.name
}


resource "aws_cloudwatch_log_resource_policy" "main" {
  count = var.elasticsearch_open_access && !var.elasticsearch_logging_disabled ? 1 : 0

  policy_name = var.name

  policy_document = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Action": [
        "logs:PutLogEvents",
        "logs:PutLogEventsBatch",
        "logs:CreateLogStream"
      ],
      "Resource": "arn:aws:logs:*"
    }
  ]
}
CONFIG
}

resource "aws_elasticsearch_domain_policy" "main" {
  count = var.elasticsearch_open_access ? 1 : 0

  domain_name = aws_elasticsearch_domain.main[0].domain_name

  access_policies = <<POLICIES
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal": "*",
            "Effect": "Allow",
            "Resource": "${aws_elasticsearch_domain.main[0].arn}/*"
        }
    ]
}
POLICIES
}
