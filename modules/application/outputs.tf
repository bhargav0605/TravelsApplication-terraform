output "webserver-ec2-ip" {
  value = aws_instance.webserver-pblc-ec2.public_ip
}

output "ssh-key-pem" {
  value = tls_private_key.my_key.private_key_pem
  sensitive = true
}