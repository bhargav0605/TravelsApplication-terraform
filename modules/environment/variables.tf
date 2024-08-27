variable "env" {
  type        = string
  description = "Environment you whant to deploy in."
  # default = "dev"
}

variable "project" {
  description = "Project Name"
  # default = "ap-south-1"
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

