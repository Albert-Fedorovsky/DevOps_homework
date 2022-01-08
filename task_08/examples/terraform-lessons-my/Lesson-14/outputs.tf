# Вывод необходимых данных по инфрастуктуре

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
output "my_web_server_public_ip_address" {
  value = aws_eip.my_static_ip.public_ip
}
