variable "name" {
  description = "rds instance name"
  type        = string
  default     = "sadcloudrds"
}

variable "no_minor_upgrade" {
  description = "do not automatically apply minor DB engine updates"
  type        = bool
  default     = false
}

variable "backup_disabled" {
  description = "disable rds instance backups"
  type        = bool
  default     = false
}


variable "storage_not_encrypted" {
  description = "do not encrypt rds instances"
  type        = bool
  default     = false
}

variable "single_az" {
  description = "only use a single availability zone with the rds instance"
  type        = bool
  default     = false
}
