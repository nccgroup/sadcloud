variable "name" {
description = "ses name"
  type        = string
  default     = "sadcloud"
}

variable "no_dkim_enabled" {
  description = "disable dkim"
  type        = bool
  default     = false
}

variable "identity_world_policy" {
  description = "Creates an open ses identity policy"
  type        = bool
  default     = false
}