variable "name" {
  description = "config name"
  type        = string
  default     = "sadcloud-config"
}

variable "config_recorder_not_configured" {
  description = "No config recorders configured"
  type        = bool
  default     = false
}
