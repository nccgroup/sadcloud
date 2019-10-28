variable "name" {
  description = "sns name"
  type        = string
  default     = "sadcloud"
}

variable "topic_world_policy" {
  description = "sns topic world policy"
  type        = bool
  default     = false
}
