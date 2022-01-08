# Вывод необходимых данных по инфрастуктуре

output "webserver_instance_id" {
  value = aws_instance.my_webserver.id
}

output "webserver_public_ip_address" {
  value = aws_eip.my_static_ip.public_ip # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
}

output "webserver_securyty_group_id" {
  value = aws_security_group.my_webserver_security_group.id
}

output "webserver_securyty_group_arn" {
  value       = aws_security_group.my_webserver_security_group.arn
  description = "This is security group ARN" # заметка она не печатается terraform
}
