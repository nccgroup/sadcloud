variable "key_rotation_disabled" {
  description = "disabled kms key rotation"
  type        = bool
  default     = false
}

variable "kms_key_exposed" {
  description = "allow wildcard access to kms key"
  type        = bool
  default     = false
}
