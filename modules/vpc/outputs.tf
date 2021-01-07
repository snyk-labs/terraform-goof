output "vpc_id" {
  value = aws_vpc.example.id
}

output "vpc_sg_id" {
  value = aws_default_security_group.default.id
}
