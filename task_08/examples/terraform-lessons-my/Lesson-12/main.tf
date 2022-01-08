# ------------------------------------------------------------------------------
# My Terraform
#
# Variables
#
# Made by Albert Fedorovsky
# ------------------------------------------------------------------------------

# https://awsregion.info/
provider "aws" {
  # region = "eu-central-1"
  region = var.region
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Create AWS elactic IP address and attach it to EC2 instace
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_web_server.id
  # tags = {
  #   Name    = "my_web_server elastic IP"
  #   Owner   = "Albert Fedorovsky"
  #   Project = "Lesson-12"
  #   Region  = var.region
  # }
  tags = merge(
    { Name = "my_web_server elastic IP" },
    var.common_tags,
    { Region = var.region }
  )
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "my_web_server" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.my_webserver_security_group.id]
  key_name               = "Frankfurt-rsa-key-pair"
  monitoring             = var.detailed_monitoring
  # tags = {
  #   Name    = "my_web_server"
  #   Owner   = "Albert Fedorovsky"
  #   Project = "Lesson-12"
  # }
  tags = merge(
    { Name = "my_web_server" },
    var.common_tags,
    { Region = var.region }
  )
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "my_webserver_security_group" {
  name = "Dynamic Security Group"
  # vpc_id      = aws_vpc.main.id

  # Allow incoming connections from the following ports:
  dynamic "ingress" {
    for_each = var.allow_ports
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

  # tags = {
  #   Name    = "my_web_server security group"
  #   Owner   = "Albert Fedorovsky"
  #   Project = "Lesson-12"
  # }
  # Пример подстановки конкретного значение из map->Environment в поле "Name"
  tags = merge(
    { Name = "${var.common_tags["Environment"]} security group" },
    var.common_tags,
    { Region = var.region }
  )
}
