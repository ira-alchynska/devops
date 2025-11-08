output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.this.id
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = [for s in values(aws_subnet.public) : s.id]
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = [for s in values(aws_subnet.private) : s.id]
}

output "internet_gateway_id" {
  description = "ID Internet Gateway"
  value       = aws_internet_gateway.igw.id
}