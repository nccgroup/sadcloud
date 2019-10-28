resource "aws_sqs_queue" "main" {
  name = var.name

  count = "${var.queue_world_policy ? 1 : 0}"
}

resource "aws_sqs_queue_policy" "main" {
  queue_url = "${aws_sqs_queue.main[0].id}"

  count = "${var.queue_world_policy ? 1 : 0}"

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
      "Resource": "${aws_sqs_queue.main[0].arn}",
      "Condition" : {
        "StringEquals" : {
          "aws:username" : "*"
        }
      }
    }
  ]
}
POLICY
}
