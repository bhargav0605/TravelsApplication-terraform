# The main VPC
resource "aws_vpc" "TravelsApplication-vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"

  tags = {
    Name = "${var.project}-${var.env}-vpc"
  }
}

# Private Subnet - Application Specific
resource "aws_subnet" "prvt-application-subnet" {
  vpc_id     = aws_vpc.TravelsApplication-vpc.id
  cidr_block = var.prvt-subnet_cidr
  # availability_zone = "ap-south-1a"

  tags = {
    Name = "${var.project}-${var.env}-prvt-subnet"
  }
}

# Public Subnet - Webserver Specific
resource "aws_subnet" "pblc-application-subnet" {
  vpc_id     = aws_vpc.TravelsApplication-vpc.id
  cidr_block = var.pblc-subnet_cidr
  # availability_zone = "ap-south-1b"

  tags = {
    Name = "${var.project}-${var.env}-pblc-subnet"
  }
}

# Internet Gateway for NAT Gateway
resource "aws_internet_gateway" "pblc-igw" {
  vpc_id = aws_vpc.TravelsApplication-vpc.id

  tags = {
    Name = "${var.project}-${var.env}-igw"
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "pblc-nat" {
  domain = "vpc"

  tags = {
    Name = "${var.project}-${var.env}-pblc-nat"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "pblc-nat" {
  allocation_id     = aws_eip.pblc-nat.id
  subnet_id         = aws_subnet.pblc-application-subnet.id
  connectivity_type = "public"

  tags = {
    Name = "${var.project}-${var.env}-pblc-nat"
  }
  depends_on = [aws_internet_gateway.pblc-igw]
}

# Public Route Table
resource "aws_route_table" "pblc-application-subnet-rt" {
  vpc_id = aws_vpc.TravelsApplication-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.pblc-igw.id
  }

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  tags = {
    Name = "${var.project}-${var.env}-pblc-rt"
  }
}

# Public Route Table Assosiation
resource "aws_route_table_association" "pblc-application-subnet-rt-asso" {
  subnet_id      = aws_subnet.pblc-application-subnet.id
  route_table_id = aws_route_table.pblc-application-subnet-rt.id
}

# Public NACLs
resource "aws_network_acl" "TravelsApplication-pblc-nacl" {
  vpc_id = aws_vpc.TravelsApplication-vpc.id
  tags = {
    Name = "${var.project}-${var.env}-pbcl-nacl"
  }
}

resource "aws_network_acl_rule" "TravelsApplication-pblc-nacl-rule-1" {
  network_acl_id = aws_network_acl.TravelsApplication-pblc-nacl.id
  rule_number    = 100
  protocol       = "all"
  egress         = true
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "TravelsApplication-pblc-nacl-rule-2" {
  network_acl_id = aws_network_acl.TravelsApplication-pblc-nacl.id
  rule_number    = 100
  protocol       = "all"
  egress         = false
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_association" "pblc-nacl" {
  subnet_id      = aws_subnet.pblc-application-subnet.id
  network_acl_id = aws_network_acl.TravelsApplication-pblc-nacl.id
}

# Private Route Table
resource "aws_route_table" "prvt-application-subnet-rt" {
  vpc_id = aws_vpc.TravelsApplication-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.pblc-nat.id
  }

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  tags = {
    Name = "${var.project}-${var.env}-prvt-rt"
  }
}

resource "aws_route_table_association" "prvt-application-subnet-rt-asso" {
  subnet_id      = aws_subnet.prvt-application-subnet.id
  route_table_id = aws_route_table.prvt-application-subnet-rt.id
}

# Private NACLs
resource "aws_network_acl" "TravelsApplication-prvt-nacl" {
  vpc_id = aws_vpc.TravelsApplication-vpc.id
  tags = {
    Name = "${var.project}-${var.env}-prvt-nacl"
  }
}

resource "aws_network_acl_rule" "TravelsApplication-prvt-nacl-rule-1" {
  network_acl_id = aws_network_acl.TravelsApplication-prvt-nacl.id
  rule_number    = 100
  protocol       = "all"
  egress         = true
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "TravelsApplication-prvt-nacl-rule-2" {
  network_acl_id = aws_network_acl.TravelsApplication-prvt-nacl.id
  rule_number    = 100
  protocol       = "all"
  egress         = false
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_association" "prvt-nacl" {
  subnet_id      = aws_subnet.prvt-application-subnet.id
  network_acl_id = aws_network_acl.TravelsApplication-prvt-nacl.id
}