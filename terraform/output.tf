output "dns_publica_server" {
    description = "DNS publica del servidor 1"
    value = "http://${aws_instance.server.public_dns}"
}
output "ip_publica_server" {
  description = "Ip Publica bastion"
  value = "ssh -i temporal.pem ec2-user@${aws_instance.server.public_ip}"
}