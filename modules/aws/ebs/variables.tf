variable "ebs_default_encryption_disabled" {
  description = "Disabled default EBS encryption"
  type        = bool
  default     = false
}

variable "ebs_volume_unencrypted" {
  description = "EBS volume not encrypted"
  type        = bool
  default     = false
}

variable "ebs_snapshot_unencrypted" {
  description = "EBS snapshot not encrypted"
  type        = bool
  default     = false
}
