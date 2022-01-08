output "data_aws_availability_zone" {
  value = data.aws_availability_zones.working.names # напечатать весь список
  # value = data.aws_availability_zones.working.names[1] # напачатать второй элемент (нумерация в списке идёт с 0)
}

output "data_aws_caller_identity" {
  value = data.aws_caller_identity.current.account_id
}

output "data_aws_region_description" {
  value = data.aws_region.current.description
}

output "aws_vpcs" {
  value = data.aws_vpcs.my_vpcs.ids
}

output "prod_vpc_id" {
  value = data.aws_vpc.prod_vpc.id
}

output "prod_vpc_cidr_block" {
  value = data.aws_vpc.prod_vpc.cidr_block
}

output "prod_subnet_1_cidr_block" {
  value = aws_subnet.prod_subnet_1.cidr_block
}

output "prod_subnet_2_cidr_block" {
  value = aws_subnet.prod_subnet_2.cidr_block
}
