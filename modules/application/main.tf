# KEY PAIR
resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
resource "aws_key_pair" "ec2-tf" {
  key_name   = "ec2-tf"
  public_key = tls_private_key.my_key.public_key_openssh
}

# EC2 in public subnet
resource "aws_instance" "webserver-pblc-ec2" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = var.pblc-environment-subnet
  associate_public_ip_address = var.enable-pblc-ip-webserver-ec2
  security_groups             = [aws_security_group.webserver-pblc-ec2-sg.id]
  key_name                    = aws_key_pair.ec2-tf.key_name

  tags = {
    Name = "${var.project}-${var.env}-webserver-ec2"
  }
}

# SECURITY
resource "aws_security_group" "webserver-pblc-ec2-sg" {
  name        = "${var.project}-${var.env}-webserver-ec2-sg"
  description = "Allow traffic to in and out of EC2."
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project}-${var.env}-webserver-ec2-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "webserver-pblc-ec2-ssh-sg-policy" {
  security_group_id = aws_security_group.webserver-pblc-ec2-sg.id
  cidr_ipv4         = var.sg-policy-cidr
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  tags = {
    Name = "${var.project}-${var.env}-ssh-webserver-ec2-ssh-sg-policy"
  }
}

resource "aws_vpc_security_group_ingress_rule" "webserver-pblc-ec2-allow-all-sg-policy" {
  security_group_id = aws_security_group.webserver-pblc-ec2-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  ip_protocol       = "-1"
  to_port           = 65535
  tags = {
    Name = "${var.project}-${var.env}-ssh-webserver-ec2-allow-all-sg-policy"
  }
}

resource "aws_vpc_security_group_egress_rule" "webserver-pblc-ec2-allow-all-out-sg-policy" {
  security_group_id = aws_security_group.webserver-pblc-ec2-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  ip_protocol       = "-1"
  to_port           = 65535
  tags = {
    Name = "${var.project}-${var.env}-ssh-webserver-ec2-allow-all-out-sg-policy"
  }
}

# EC2 in private subnet
resource "aws_instance" "application-prvt-ec2" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = var.prvt-environment-subnet
  associate_public_ip_address = var.enable-prvt-ip-application-ec2
  security_groups             = [aws_security_group.application-prvt-ec2-sg.id]
  key_name                    = aws_key_pair.ec2-tf.key_name

  tags = {
    Name = "${var.project}-${var.env}-application-ec2"
  }
}

# SECURITY
resource "aws_security_group" "application-prvt-ec2-sg" {
  name        = "${var.project}-${var.env}-application-prvt-ec2-sg"
  description = "Allow traffic to in and out of EC2."
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project}-${var.env}-application-prvt-ec2-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "application-prvt-ec2-ssh-sg-policy" {
  security_group_id = aws_security_group.application-prvt-ec2-sg.id
  cidr_ipv4         = var.sg-policy-cidr
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  tags = {
    Name = "${var.project}-${var.env}-ssh-application-ec2-ssh-sg-policy"
  }
}

resource "aws_vpc_security_group_ingress_rule" "application-prvt-ec2-allow-all-sg-policy" {
  security_group_id = aws_security_group.application-prvt-ec2-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  ip_protocol       = "-1"
  to_port           = 65535
  tags = {
    Name = "${var.project}-${var.env}-application-ec2-allow-all-sg-policy"
  }
}

resource "aws_vpc_security_group_egress_rule" "application-prvt-ec2-allow-all-out-sg-policy" {
  security_group_id = aws_security_group.application-prvt-ec2-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  ip_protocol       = "-1"
  to_port           = 65535
  tags = {
    Name = "${var.project}-${var.env}-application-ec2-allow-all-out-sg-policy"
  }
}
