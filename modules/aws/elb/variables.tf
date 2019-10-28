variable "name" {
  description = "elb classic name"
  type        = string
  default     = "sadcloud-elb"
}

variable "no_access_logs" {
  description = "No elb classic access logs configured"
  type        = bool
  default     = false
}
