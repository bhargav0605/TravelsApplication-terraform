output "eib" {
  value = module.environment.eip
}

output "vpc_id" {
  value = module.environment.vpc_id
}

output "webserver-ec2-ip" {
  value = module.application.webserver-ec2-ip
}

output "ssh-pem" {
  value     = module.application.ssh-key-pem
  sensitive = true
}

output "application-ec2-ip" {
  value = module.application.application-ec2-ip
}