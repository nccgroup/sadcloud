variable "name" {
  description = "stack name"
  type        = string
  default     = "sadcloud-s3-stack"
}

variable "stack_with_role" {
  description = "attach iam role to stack"
  type        = bool
  default     = false
}

variable "stack_with_secret_output" {
  description = "secrets in CloudFormation output"
  type        = bool
  default     = false
}
