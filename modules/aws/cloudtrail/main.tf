data "aws_caller_identity" "current" {}

resource "aws_cloudtrail" "main" {
  count = var.not_configured ? 0 : 1
  depends_on = [aws_s3_bucket_policy.CloudTrailS3Bucket-Policy]

  name = var.name
  s3_bucket_name = var.no_logging ? null : aws_s3_bucket.logging[0].bucket

  include_global_service_events = (var.duplicated_global_services_logging || !var.no_global_services_logging)
  enable_logging = !var.no_logging
  enable_log_file_validation = !var.no_log_file_validation

  dynamic "event_selector" {
    for_each = var.no_data_logging == true ? [] : list(var.no_data_logging)

    content {
      read_write_type           = "All"
      include_management_events = true

      data_resource {
        type   = "AWS::S3::Object"
        values = ["arn:aws:s3:::"]
      }
    }
  }
}

resource "aws_s3_bucket" "logging" {
  bucket_prefix = var.name
  force_destroy = true

  count = var.no_logging ? 0 : 1
}

resource "aws_s3_bucket_policy" "CloudTrailS3Bucket-Policy" {
  bucket = aws_s3_bucket.logging[0].id
  depends_on = [aws_s3_bucket.logging[0]]

  count = var.no_logging ? 0 : 1

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [{
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": { "Service": "cloudtrail.amazonaws.com" },
            "Action": "s3:GetBucketAcl",
            "Resource": "${aws_s3_bucket.logging[0].arn}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": { "Service": "cloudtrail.amazonaws.com" },
            "Action": "s3:PutObject",
            "Resource": ["${aws_s3_bucket.logging[0].arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"],
            "Condition": { "StringEquals": { "s3:x-amz-acl": "bucket-owner-full-control" } }
        }]

}
POLICY
}

resource "aws_cloudtrail" "duplicate" {
  depends_on = [aws_s3_bucket_policy.CloudTrailS3Bucket-Policy]
  name = "duplicatesadcloud"
  include_global_service_events = true
  s3_bucket_name = aws_s3_bucket.logging[0].bucket

  count = (var.duplicated_global_services_logging && !var.no_data_logging) ? 1 : 0
}
