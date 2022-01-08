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
resource "aws_instance" "my_webserver" {
  ami                    = "ami-05d34d340fb1d89e5" # Amazon linux ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver_security_group.id]
  key_name               = "Frankfurt-rsa-key-pair"
  user_data = templatefile("user-data.sh.tpl", {
    f_name = "Albert",
    l_name = "Fedorovsky",
    names  = ["Vasya", "Kolya", "Petya", "Jonh", "Donald", "Masha"]
  })

  tags = {
    Name    = "Web server build by terraform"
    Owner   = "Albert Fedorovsky"
    Project = "Terraform lessons"
  }

}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "my_webserver_security_group" {
  name        = "Webserver Security Group"
  description = "My firs Security security_group"
  # vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow incoming http connections"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # pv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  ingress {
    description = "Allow incoming https connections"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # pv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  ingress {
    description = "Allow incoming SSH connections"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # pv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  /*
  ingress {
    description = "Allow incoming ping from any hosts"
    from_port   = "-1"
    to_port     = "-1"
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    # pv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }
*/

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
