env                          = "dev"
vpc_cidr                     = "10.0.0.0/16"
prvt-subnet_cidr             = "10.0.1.0/24"
pblc-subnet_cidr             = "10.0.2.0/24"
enable-pblc-ip-webserver-ec2 = true
instance_type                = "t3.micro"
sg-policy-cidr               = "0.0.0.0/0"
enable-prvt-ip-webserver-ec2 = false