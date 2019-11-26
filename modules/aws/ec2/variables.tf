variable "name" {
  description = "Name for instances and group"
  type        = string
  default     = "sadcloud-ec2"
}

############## Network ##############

variable "vpc_id" {
  description = "ID of created VPC"
  default = "default_vpc_id"
}

variable "main_subnet_id" {
  description = "ID of created VPC"
  default = "default_main_subnet_id"
}

############## Findings ##############

variable "disallowed_instance_type" {
  description = "use a disallowed instance type"
  type        = bool
  default     = false
}

variable "instance_with_public_ip" {
  description = "use a public ip with this instance"
  type        = bool
  default     = false
}

variable "instance_with_user_data_secrets" {
  description = "supply user data secrets to the instance"
  type        = bool
  default     = false
}

variable "security_group_opens_all_ports_to_all" {
  description = "security group with all ports open to all"
  type        = bool
  default     = false
}

variable "security_group_opens_all_ports_to_self" {
  description = "security group that permits unrestricted network traffic within itself"
  type        = bool
  default     = false
}

variable "security_group_opens_icmp_to_all" {
  description = "ICMP open to all"
  type        = bool
  default     = false
}

variable "security_group_opens_known_port_to_all" {
  description = "well known port open to all"
  type        = bool
  default     = false
}

variable "security_group_opens_plaintext_port" {
  description = "plain text port open to all"
  type        = bool
  default     = false
}

variable "security_group_opens_port_range" {
  description = "use of port ranges"
  type        = bool
  default     = false
}

variable "security_group_opens_port_to_all" {
  description = "port open to all"
  type        = bool
  default     = false
}

variable "security_group_whitelists_aws_ip_from_banned_region" {
  description = "security group whitelists AWS IPs outside the USA"
  type        = bool
  default     = false
}

variable "security_group_whitelists_aws" {
  description = "security group whitelists AWS IPs"
  type        = bool
  default     = false
}

variable "ec2_security_group_whitelists_unknown_cidrs" {
  description = "security group whitelists unknown CIDRs"
  type        = bool
  default     = false
}

variable "ec2_unused_security_group" {
  description = "unused security groups"
  type        = bool
  default     = false
}

variable "ec2_unneeded_security_group" {
  description = "security group cidr cannot be blocked"
  type        = bool
  default     = false
}

variable "ec2_unexpected_security_group" {
  description = "security group cidr oddly formatted"
  type        = bool
  default     = false
}

variable "ec2_overlapping_security_group" {
  description = "security group cidrs overlap"
  type        = bool
  default     = false
}
