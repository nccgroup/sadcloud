
output "vpc_id" {
  description = "ID of created VPC"
  value       = aws_vpc.main[0].id
}

output "vpc_cidr" {
  description = "CIDR of created VPC"
  value       = aws_vpc.main[0].cidr_block
}

output "main_subnet_id" {
  description = "ID of created subnet"
  value       = aws_subnet.main[0].id
}

output "secondary_subnet_id" {
  description = "ID of created secondary subnet"
  value       = aws_subnet.secondary[0].id
}

output "subnet_cidr" {
  description = "CIDR of created subnet"
  value       = aws_vpc.main[0].cidr_block
}
