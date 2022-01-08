# ------------------------------------------------------------------------------
# My Terraform
#
# Find Latest AMI id of:
# - Ubuntu 18.04
# - Amazon Linux 2
# - Windows Server 2016 Base
#
# Made by Albert Fedorovsky
# ------------------------------------------------------------------------------

# https://awsregion.info/
provider "aws" {
  region = "eu-central-1"
  # region = "ca-central-1"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami
data "aws_ami" "latest_ubuntu_20" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-*-x86_64-gp2"]
  }
}

data "aws_ami" "latest_windows_server_2019" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-*"]
  }
}

resource "aws_instance" "my_database_server_ubuntu_20" {
  ami                    = data.aws_ami.latest_ubuntu_20.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver_security_group.id]
  key_name               = "Frankfurt-rsa-key-pair"

  tags = {
    Name = "my_database_server"
  }
}

resource "aws_security_group" "my_webserver_security_group" {
  name = "Dynamic Security Group"
  # vpc_id      = aws_vpc.main.id

  # Allow incoming connections from the following ports:
  dynamic "ingress" {
    for_each = ["22", "80", "443"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name    = "Web server security group"
    Owner   = "Albert Fedorovsky"
    Project = "Terraform lessons"
  }
}
