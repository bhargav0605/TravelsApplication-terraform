variable "env" {
  type        = string
  description = "Environment you whant to deploy in."
  # default = "dev"
}

variable "project" {
  description = "Project Name"
  # default = "ap-south-1"
}

variable "vpc_id" {
  description = "VPC ID where the EC2 instance will be deployed"
  type        = string
}

variable "pblc-environment-subnet" {
  description = "Public subnet ID for the EC2 instance"
  type        = string
}

variable "enable-pblc-ip-webserver-ec2" {
  description = "Enable or disable public IP allocation."
  type        = bool
}

variable "enable-prvt-ip-application-ec2" {
  description = "Enable or disable public IP allocation."
  type        = bool
  default     = false
}

variable "instance_type" {
  description = "Type of the ec2 instance."
  type        = string
}

variable "sg-policy-cidr" {
  description = "CIDR of created vpc."
  type        = string
}

variable "prvt-environment-subnet" {
  description = "Private subnet ID for the EC2 instance"
  type        = string
}