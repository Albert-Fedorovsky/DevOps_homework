# Infrastructure data output

output "main_securyty_group_id" {
  value = aws_security_group.main.id
}

output "main_securyty_group_arn" {
  value       = aws_security_group.main.arn
  description = "This is security group ARN" # not prin out
}

output "instances_ami_id" {
  value = data.aws_ami.latest_amazon_linux.id
}

output "instances_ami_name" {
  value = data.aws_ami.latest_amazon_linux.name
}

output "instance_key_name" {
  value = var.instance_key_name
}

output "main_loadbalancer_url" {
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

output "index_html_bucket_arn" {
  value = aws_s3_bucket.main.arn
}
