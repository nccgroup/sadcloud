variable "name" {
  description = "ecr name"
  type        = string
  default     = "sadcloud"
}

variable "ecr_scanning_disabled" {
  description = "disabled ecr scanning"
  type        = bool
  default     = false
}

variable "ecr_repo_public" {
  description = "ECR repositories set to Public"
  type        = bool
  default     = false
}
