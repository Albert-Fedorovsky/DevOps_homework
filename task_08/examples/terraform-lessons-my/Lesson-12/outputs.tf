# Вывод необходимых данных по инфрастуктуре

output "my_web_server_instance_id" {
  value = aws_instance.my_web_server.id
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
output "my_web_server_public_ip_address" {
  value = aws_eip.my_static_ip.public_ip
}

output "my_web_server_securyty_group_id" {
  value = aws_security_group.my_webserver_security_group.id
}

output "webserver_securyty_group_arn" {
  value       = aws_security_group.my_webserver_security_group.arn
  description = "This is security group ARN" # заметка она не печатается terraform
}
