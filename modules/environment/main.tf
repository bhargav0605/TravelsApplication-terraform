# The main VPC
resource "aws_vpc" "TravelsApplication-vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = "true"

  tags = {
    Name = "${var.project}-${var.env}-vpc"
  }
}

# Private Subnet - Application Specific
resource "aws_subnet" "prvt-application-subnet" {
  vpc_id     = aws_vpc.TravelsApplication-vpc.id
  cidr_block = var.prvt-subnet_cidr

  tags = {
    Name = "${var.project}-${var.env}-prvt-subnet"
  }
}

# Public Subnet - Webserver Specific
resource "aws_subnet" "pblc-application-subnet" {
  vpc_id     = aws_vpc.TravelsApplication-vpc.id
  cidr_block = var.pblc-subnet_cidr

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

resource "aws_route_table_association" "pblc-application-subnet-rt-asso" {
  subnet_id      = aws_subnet.pblc-application-subnet.id
  route_table_id = aws_route_table.pblc-application-subnet-rt.id
}

# Private Route Table
resource "aws_route_table" "prvt-application-subnet-rt" {
  vpc_id = aws_vpc.TravelsApplication-vpc.id

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

# NACLs
resource "aws_network_acl" "TravelsApplication-pblc-nacl" {
  vpc_id = aws_vpc.TravelsApplication-vpc.id

  egress {
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "${var.project}-${var.env}-pbcl-nacl"
  }
}

# Private NACL
resource "aws_network_acl" "TravelsApplication-prvt-nacl" {
  vpc_id = aws_vpc.TravelsApplication-vpc.id

  egress {
    protocol   = "all"
    rule_no    = 100
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "all"
    rule_no    = 100
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "${var.project}-${var.env}-prvt-nacl"
  }
}

resource "aws_network_acl_association" "pblc-nacl" {
  subnet_id      = aws_subnet.pblc-application-subnet.id
  network_acl_id = aws_network_acl.TravelsApplication-pblc-nacl.id
}

resource "aws_network_acl_association" "prvt-nacl" {
  subnet_id      = aws_subnet.prvt-application-subnet.id
  network_acl_id = aws_network_acl.TravelsApplication-prvt-nacl.id
}


# Elastic IP for NAT Gateway
resource "aws_eip" "pblc-nat" {
  domain   = "vpc"

  tags = {
    Name = "${var.project}-${var.env}-pblc-nat"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "pblc-nat" {
  allocation_id = aws_eip.pblc-nat.id
  subnet_id     = aws_subnet.pblc-application-subnet.id

  tags = {
    Name = "${var.project}-${var.env}-pblc-nat"
  }
  depends_on = [aws_internet_gateway.pblc-igw]
}
