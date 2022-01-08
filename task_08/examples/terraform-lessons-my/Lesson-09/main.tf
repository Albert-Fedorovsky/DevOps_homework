provider "aws" {
  region = "eu-central-1"
}

# data - информация по ресурсам, которую можно получить от облачной платформы
# https://www.terraform.io/language/data-sources

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones
data "aws_availability_zones" "working" {}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity
data "aws_caller_identity" "current" {}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region
data "aws_region" "current" {}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpcs
data "aws_vpcs" "my_vpcs" {}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
data "aws_vpc" "prod_vpc" {
  tags = {
    Name = "my_default_vpc"
    # Name = "prod"
  }
}

resource "aws_subnet" "prod_subnet_1" {
  vpc_id            = data.aws_vpc.prod_vpc.id
  availability_zone = data.aws_availability_zones.working.names[0]
  cidr_block        = "172.31.48.0/20"
  # cidr_block = "10.0.1.0/24"
  tags = {
    Name    = "Subnet-1 in ${data.aws_availability_zones.working.names[0]}"
    Account = "Subnet in account ${data.aws_caller_identity.current.account_id}"
    Region  = data.aws_region.current.description
  }
}

resource "aws_subnet" "prod_subnet_2" {
  vpc_id            = data.aws_vpc.prod_vpc.id
  availability_zone = data.aws_availability_zones.working.names[1]
  cidr_block        = "172.31.64.0/20"
  # cidr_block = "10.0.2.0/24"
  tags = {
    Name    = "Subnet-2 in ${data.aws_availability_zones.working.names[1]}"
    Account = "Subnet in account ${data.aws_caller_identity.current.account_id}"
    Region  = data.aws_region.current.description
  }
}
