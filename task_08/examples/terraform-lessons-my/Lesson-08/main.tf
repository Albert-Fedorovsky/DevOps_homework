# ------------------------------------------------------------------------------
# My Terraform
#
# Build WebServer during Bootsrap
#
# Made by Albert Fedorovsky
# ------------------------------------------------------------------------------

# https://awsregion.info/
provider "aws" {
  region = "eu-central-1"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "my_web_server" {
  ami                    = "ami-05d34d340fb1d89e5" # Amazon linux ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver_security_group.id]
  key_name               = "Frankfurt-rsa-key-pair"

  tags = {
    Name = "my_web_server"
  }

  # Зависимость, ресурс будет создан только после того, как будет создан
  # указанные в зависимоссти ресурсы. При унечтожении последовательность
  # обратная: ресурсы, от которых зависят другие удаляются последними
  depends_on = [aws_instance.my_database_server, aws_instance.my_application_server]
}

resource "aws_instance" "my_application_server" {
  ami                    = "ami-05d34d340fb1d89e5" # Amazon linux ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver_security_group.id]
  key_name               = "Frankfurt-rsa-key-pair"

  tags = {
    Name = "my_application_server"
  }

  # Зависимость, ресурс будет создан только после того, как будет создан
  # указанный в зависимоссти ресурс. При унечтожении последовательность
  # обратная: ресурс, от которого зависят другие удаляется последним
  depends_on = [aws_instance.my_database_server]
}

resource "aws_instance" "my_database_server" {
  ami                    = "ami-05d34d340fb1d89e5" # Amazon linux ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver_security_group.id]
  key_name               = "Frankfurt-rsa-key-pair"

  tags = {
    Name = "my_database_server"
  }
}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
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
