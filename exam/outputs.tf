# Infrastructure data output

output "main_securyty_group_id" {
  value = aws_security_group.main.id
}

output "main_securyty_group_arn" {
  value       = aws_security_group.main.arn
  description = "This is security group ARN" # not prin out
}

output "webserrvers_ami_id" {
  value = data.aws_ami.latest_amazon_linux.id
}

output "webserrvers_ami_name" {
  value = data.aws_ami.latest_amazon_linux.name
}

# output "jenkins_ami_id" {
#   value = data.aws_ami.latest_ubuntu_20.id
# }
output "jenkins_ami_id" {
  value = data.aws_ami.my_jenkins_on_ubuntu_20.id
}

# output "jenkins_ami_name" {
#   value = data.aws_ami.latest_ubuntu_20.name
# }
output "jenkins_ami_name" {
  value = data.aws_ami.my_jenkins_on_ubuntu_20.name
}

output "instance_key_name" {
  value = var.instance_key_name
}

output "main_loadbalancer_URL" {
  value = aws_lb.main.dns_name
}

output "aws_availability_zones" {
  value = data.aws_availability_zones.available.names # print all list of names
  # value = data.aws_availability_zones.working.names[1] # print only 2 name (numeric from 0)
}

output "aws_caller_identity" {
  value = data.aws_caller_identity.current.account_id
}

output "aws_region_description" {
  value = data.aws_region.current.description
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_cidr_block" {
  value = aws_vpc.main.cidr_block
}

output "subnet_a_cidr_block" {
  value = aws_subnet.public_a.cidr_block
}

output "subnet_b_cidr_block" {
  value = aws_subnet.public_b.cidr_block
}

output "webserver_1_private_ip" {
  value = aws_instance.web_server_1.private_ip
}

output "webserver_2_private_ip" {
  value = aws_instance.web_server_2.private_ip
}

output "webserver_1_public_ip" {
  value = aws_instance.web_server_1.public_ip
}

output "webserver_2_public_ip" {
  value = aws_instance.web_server_2.public_ip
}
