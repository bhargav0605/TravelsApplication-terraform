# KEY PAIR
resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
resource "aws_key_pair" "ec2-tf" {
  key_name   = "ec2-tf"
  public_key = tls_private_key.my_key.public_key_openssh
  # public_key = file("/Users/bhargavparmar/.ssh/ec2-tf.pub")
}

# EC2 in public subnet
resource "aws_instance" "webserver-pblc-ec2" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = var.pblc-environment-subnet
  associate_public_ip_address = var.enable-pblc-ip-webserver-ec2
  security_groups             = [aws_security_group.webserver-pblc-ec2-sg.id]
  key_name = aws_key_pair.ec2-tf.key_name

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

resource "aws_vpc_security_group_ingress_rule" "webserver-pblc-ec2-sg-policy" {
  security_group_id = aws_security_group.webserver-pblc-ec2-sg.id
  cidr_ipv4         = var.sg-policy-cidr
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  tags = {
    Name = "${var.project}-${var.env}-ssh-webserver-ec2-sg-policy"
  }

}


