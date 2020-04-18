#-----networking/outputs.tf----

output "private_subnets" {
  value = aws_subnet.tf_private_subnet.*.id
}

output "public_subnets" {
  value = aws_subnet.tf_public_subnet.*.id
}

output "private_sg" {
  value = aws_security_group.tf_private_sg.id
}

output "public_sg" {
  value = aws_security_group.tf_public_sg.id
}

output "main_vpc" {
  value = aws_vpc.tf_vpc.id
}

output "subnet_ips" {
  value = aws_subnet.tf_public_subnet.*.cidr_block
}

output "redis_subnet" {
  value = aws_elasticache_subnet_group.tf_redis_subnet.id
}