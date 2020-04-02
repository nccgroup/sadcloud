resource "aws_s3_bucket" "main" {
  bucket_prefix = var.name
  acl    = "private"
  force_destroy = true

  dynamic "server_side_encryption_configuration" {
    for_each = var.no_default_encryption ? [] : list(var.no_default_encryption)

    content {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = "AES256"
        }
      }
    }
  }

  dynamic "logging" {
    for_each = var.no_logging ? [] : list(var.no_logging)

    content {
      target_bucket = aws_s3_bucket.logging[0].id
      target_prefix = var.name
    }
  }

  versioning {
      enabled = var.no_versioning ? false : true
      mfa_delete = false
  }

  dynamic "website" {
    for_each = var.website_enabled ? [] : list(var.website_enabled)

    content {
      index_document = "index.html"
    }
  }
}

resource "aws_s3_bucket" "logging" {
  bucket_prefix = var.name
  acl    = var.bucket_acl
  force_destroy = true

  count = var.no_logging ? 0 : 1
}

data "aws_iam_policy_document" "force_ssl_only_access" {
  # Force SSL access
  statement {
    sid = "ForceSSLOnlyAccess"

    effect = "Deny"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = ["s3:*"]

    resources = [
      aws_s3_bucket.main.arn,
      "${aws_s3_bucket.main.arn}/*",
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "force_ssl_only_access" {
  bucket = aws_s3_bucket.main.id
  policy = data.aws_iam_policy_document.force_ssl_only_access.json

  count = var.allow_cleartext ? 1 : 0
}

data "aws_iam_policy_document" "getonly" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = ["s3:GetObject"]

    resources = [
      aws_s3_bucket.getonly[0].arn,
      "${aws_s3_bucket.getonly[0].arn}/*",
    ]
  }

  count = var.s3_getobject_only ? 1 : 0
}

resource "aws_s3_bucket" "getonly" {
  bucket_prefix = "sadcloudhetonlys3"
  force_destroy = true

  count = var.s3_getobject_only ? 1 : 0
}

resource "aws_s3_bucket_policy" "getonly" {
  bucket = aws_s3_bucket.getonly[0].id
  policy = data.aws_iam_policy_document.getonly[0].json

  count = var.s3_getobject_only ? 1 : 0
}


data "aws_iam_policy_document" "public" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = ["s3:*"]

    resources = [
      aws_s3_bucket.public[0].arn,
      "${aws_s3_bucket.public[0].arn}/*",
    ]
  }

  count = var.s3_public ? 1 : 0
}

resource "aws_s3_bucket" "public" {
  bucket_prefix = "sadcloudhetonlys3"
  force_destroy = true

  count = var.s3_public ? 1 : 0
}

resource "aws_s3_bucket_policy" "public" {
  bucket = aws_s3_bucket.public[0].id
  policy = data.aws_iam_policy_document.public[0].json

  count = var.s3_public ? 1 : 0
}
