variable "project" {
  description = "Project Name"
  # default = "ap-south-1"
}

variable "region" {
  description = "Provide Region"
  default     = "ap-south-1"
}

variable "env" {
  description = "Environment you whant to deploy in."
  # default = "dev"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR Block"
  # default = "10.0.0.0/16"
}

variable "prvt-subnet_cidr" {
  type        = string
  description = "Private Subnet CIDR Block"
  # default = "10.0.1.0/24"
}

variable "pblc-subnet_cidr" {
  type        = string
  description = "Public Subnet CIDR Block"
  # default = "10.0.2.0/24"
}

variable "enable-pblc-ip-webserver-ec2" {
  type        = bool
  description = "Enable public ip of webserver ec2."
}


variable "enable-prvt-ip-webserver-ec2" {
  type        = bool
  description = "Enable public ip of webserver ec2."
}

variable "instance_type" {
  type        = string
  description = "Type of EC2 instance."
}

variable "sg-policy-cidr" {
  type        = string
  description = "CIDR block to allow inbound to ec2 from."

}