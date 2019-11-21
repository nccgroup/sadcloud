variable "name" {
  description = "sqs name"
  type        = string
  default     = "sadcloud"
}

variable "queue_world_policy" {
  description = "sqs queue world policy"
  type        = bool
  default     = false
}

variable "sqs_server_side_encryption_disabled" {
  description = "sqs server side encryption disabled"
  type        = bool
  default     = false
}
