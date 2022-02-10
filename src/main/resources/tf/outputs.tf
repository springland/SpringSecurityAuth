output "certinstance_public_ip" {
  value = aws_instance.certinstance.public_ip
}

output "certinstance_public_dns" {
  value = aws_instance.certinstance.public_dns
}
