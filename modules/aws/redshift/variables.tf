variable "name" {
  description = "redshift name"
  type        = string
  default     = "sadcloud"
}

variable "parameter_group_ssl_not_required" {
  description = "allow cleartext connections"
  type        = bool
  default     = false
}

variable "parameter_group_logging_disabled" {
  description = "disable logging"
  type        = bool
  default     = false
}

variable "cluster_publicly_accessible" {
  description = "enable public access to cluster"
  type        = bool
  default     = false
}

variable "cluster_no_version_upgrade" {
  description = "disable automatic version upgrades"
  type        = bool
  default     = false
}

variable "cluster_database_not_encrypted" {
  description = "disable database encryption"
  type        = bool
  default     = false
}
