resource "aws_sqs_queue" "main" {
  name = var.name

  kms_master_key_id  = var.sqs_server_side_encryption_disabled ? null : "alias/aws/sqs"
  kms_data_key_reuse_period_seconds = var.sqs_server_side_encryption_disabled ? null : 300

  count = (var.queue_world_policy || var.sqs_server_side_encryption_disabled) ? 1 : 0
}

resource "aws_sqs_queue_policy" "main" {
  queue_url = aws_sqs_queue.main[0].id

  count = var.queue_world_policy ? 1 : 0

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:*",
      "Resource": "${aws_sqs_queue.main[0].arn}"
    }
  ]
}
POLICY
}
