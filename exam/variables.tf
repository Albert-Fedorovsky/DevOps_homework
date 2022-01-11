variable "region" {
  description = "AWS region name to deploy infrastructure"
  type        = string
  default     = "eu-central-1"
}

variable "instance_type" {
  description = "AWS EC2 instance type to launch configuration"
  type        = string
  default     = "t2.micro"
}

variable "instance_key_name" {
  description = "Name of key for access to EC2 instances"
  type        = string
  default     = "Frankfurt-rsa-key-pair"
}

variable "instance_public_ip_enable" {
  description = "Enable public IP for instances"
  type        = bool
  default     = true
}

variable "common_tags" {
  description = "Common Tags to apply all Resources"
  type        = map(any)
  default = {
    Owner         = "Albert Fedorovsky",
    Project       = "andersen-dev-ops-exam",
    Stack-version = "0.1"
    Environment   = "development"
  }
}

variable "main_vpc_cidr_block" {
  description = "Main VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "main_sg_allow_ports" {
  description = "Main security group list of port to incoming connections."
  type        = list(any)
  default     = ["22", "80", "443", "8080"]
}

variable "public_subnet_a_cidr_block" {
  description = "Public subnet a cidr block"
  type        = string
  default     = "10.0.10.0/24"
}

variable "public_subnet_b_cidr_block" {
  description = "Public subnet a cidr block"
  type        = string
  default     = "10.0.20.0/24"
}

variable "web_server_1_private_ip" {
  description = "Private IP of webserver 1"
  type        = string
  default     = "10.0.10.10"
}

variable "web_server_2_private_ip" {
  description = "Private IP of webserver 2"
  type        = string
  default     = "10.0.20.10"
}
