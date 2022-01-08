# ------------------------------------------------------------------------------
# My Terraform
#
# Local Variables
#
# Made by Albert Fedorovsky
# ------------------------------------------------------------------------------

# https://awsregion.info/
provider "aws" {
  region = "eu-central-1"
}

data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

# Local variables
locals {
  full_project_name = "${var.environment}-${var.project_name}"
  project_owner     = "${var.owner} owner of ${var.project_name}"
}

locals {
  country  = "Russia"
  city     = "Rostov-on-Don"
  az_list  = join(", ", data.aws_availability_zones.available.names)
  region   = data.aws_region.current.description
  location = "${local.region} there are AZ: ${local.az_list}"
}

# Create AWS elactic IP address and attach it to EC2 instace
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
resource "aws_eip" "my_static_ip" {
  tags = {
    Name       = "Elastic IP"
    Owner      = "Albert Fedorovsky"
    Project    = local.full_project_name
    proj_owner = local.project_owner
    city       = local.city
    region_azs = local.az_list
    location   = local.location
  }
}
