variable "name" {
  description = "es name"
  type        = string
  default     = "sadcloud"
}

variable "elasticsearch_logging_disabled" {
  description = "Elasticsearch Service domains have logging disabled"
  type        = bool
  default     = false
}

variable "elasticsearch_open_access" {
  description = "Elasticsearch Service domains have open access"
  type        = bool
  default     = false
}
