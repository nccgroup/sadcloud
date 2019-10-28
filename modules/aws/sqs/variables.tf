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
