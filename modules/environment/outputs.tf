output "vpc_id" {
  value = aws_vpc.TravelsApplication-vpc.id
}

output "vpc_arn" {
  value = aws_vpc.TravelsApplication-vpc.arn
}

output "vpc_cidr" {
  value = aws_vpc.TravelsApplication-vpc.cidr_block
}

output "vpc_nacl" {
  value = aws_vpc.TravelsApplication-vpc.default_network_acl_id
}

output "prvt-subnet-id" {
  value = aws_subnet.prvt-application-subnet.id
}

output "pblc-subnet-id" {
  value = aws_subnet.pblc-application-subnet.id
}

output "eip" {
  value = aws_eip.pblc-nat
}