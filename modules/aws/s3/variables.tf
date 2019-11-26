variable "name" {
  description = "bucket name"
  type        = string
  default     = "sadcloud"
}

variable "logging_bucket" {
  description = "Logging bucket used for this bucket"
  type        = string
  default     = "sadcloud_logs"
}

variable "bucket_acl" {
  description = "Canned acl"
  type        = string
  default     = "log-delivery-write"
}

variable "sse_algorithm" {
  description = "Encryption algorithm to use"
  type        = string
  default     = "AES256"
}

variable "allow_cleartext" {
  description = "should the bucket allow HTTP"
  type        = bool
  default     = false
}

variable "no_default_encryption" {
  description = "should the bucket disable encryption"
  type        = bool
  default     = false
}

variable "no_logging" {
  description = "should the bucket disable logging"
  type        = bool
  default     = false
}

variable "no_versioning" {
  description = "should the bucket disable versioning"
  type        = bool
  default     = false
}

variable "website_enabled" {
  description = "should the bucket enable the website"
  type        = bool
  default     = false
}

variable "s3_getobject_only" {
  description = "internet accessible s3 bucket (only GetObject)"
  type        = bool
  default     = false
}

variable "s3_public" {
  description = "internet accessible s3 bucket"
  type        = bool
  default     = false
}
