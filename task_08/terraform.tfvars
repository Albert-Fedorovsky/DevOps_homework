# Auto fill variables for production
# https://www.terraform.io/language/values/variables
# File can nammed as terraform.tfvars or *.auto.tfvars

region                    = "eu-central-1"
instance_type             = "t2.micro"
instance_key_name         = "Frankfurt-rsa-key-pair"
instance_public_ip_enable = true
common_tags = {
  Owner         = "Albert Fedorovsky",
  Project       = "task-08",
  Stack_version = "1.0",
  Environment   = "production"
}
main_vpc_cidr_block        = "10.0.0.0/16"
main_sg_allow_ports        = ["22", "80", "443"]
public_subnet_a_cidr_block = "10.0.10.0/24"
public_subnet_b_cidr_block = "10.0.20.0/24"
