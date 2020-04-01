variable "name" {
  description = "eks cluster name"
  type        = string
  default     = "sadcloud"
}

variable "out_of_date" {
  description = "EKS Cluster Version is out of date"
  type        = string
  default     = false
}

variable "no_logs" {
  description = "EKS Cluster lacks audit logging"
  type        = string
  default     = false
}

variable "publicly_accessible" {
  description = "EKS Cluster is publically accessible"
  type        = string
  default     = false
}

variable "globally_accessible" {
  description = "EKS Cluster is globally accessible"
  type        = string
  default     = false
}

############## Network ##############

variable "vpc_id" {
  description = "ID of created VPC"
  default = "default_vpc_id"
}

variable "main_subnet_id" {
  description = "ID of main subnet"
  default = "default_main_subnet_id"
}

variable "secondary_subnet_id" {
  description = "ID of secondary subnet"
  default = "default_secondary_subnet_id"
}
