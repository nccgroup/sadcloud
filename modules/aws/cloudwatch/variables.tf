variable "name" {
  description = "cloudwatch name"
  type        = string
  default     = "sadcloud-cloudwatch"
}

variable "alarm_without_actions" {
  description = "cloudwatch alarm lacks actions"
  type        = bool
  default     = false
}
