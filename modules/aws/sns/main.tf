resource "aws_sns_topic" "main" {
  name = var.name

  count = var.topic_world_policy ? 1 : 0
}

resource "aws_sns_topic_policy" "main-policy" {
  arn = aws_sns_topic.main[0].arn

  policy = data.aws_iam_policy_document.sns-topic-policy[0].json
  count = var.topic_world_policy ? 1 : 0
}


data "aws_iam_policy_document" "sns-topic-policy" {
  statement {
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      aws_sns_topic.main[0].arn,
    ]
  }
  count = var.topic_world_policy ? 1 : 0
}
