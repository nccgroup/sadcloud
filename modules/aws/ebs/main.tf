resource "aws_ebs_volume" "main" {
  availability_zone = "us-east-1a"
  size              = 1
  encrypted = !var.ebs_volume_unencrypted

  count = var.ebs_volume_unencrypted || var.ebs_snapshot_unencrypted ? 1 : 0
}

resource "aws_ebs_encryption_by_default" "main" {
  enabled = !var.ebs_default_encryption_disabled

  count = var.ebs_default_encryption_disabled ? 1 : 0
}

resource "aws_ebs_snapshot" "main_snapshot" {
  volume_id = aws_ebs_volume.main[0].id

  count = var.ebs_snapshot_unencrypted ? 1 : 0
}
