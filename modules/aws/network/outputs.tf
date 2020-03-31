
output "vpc_id" {
  description = "ID of created VPC"
  value       = length(aws_vpc.main) > 0 ? aws_vpc.main[0].id : null
}

output "vpc_cidr" {
  description = "CIDR of created VPC"
  value       = length(aws_vpc.main) > 0 ? aws_vpc.main[0].cidr_block : null
}

output "main_subnet_id" {
  description = "ID of created subnet"
  value       = length(aws_subnet.main) > 0 ? aws_subnet.main[0].id : null
}

output "secondary_subnet_id" {
  description = "ID of created secondary subnet"
  value       = length(aws_subnet.secondary) > 0 ? aws_subnet.secondary[0].id : null
}

output "subnet_cidr" {
  description = "CIDR of created subnet"
  value       = length(aws_vpc.main) > 0 ? aws_vpc.main[0].id : null
}
