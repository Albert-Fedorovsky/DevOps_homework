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
  user_data              = <<EOF
#!/bin/bash -xe
echo "Terraform Script" > /home/ec2-user/init-info.txt
yum update -y
amazon-linux-extras list | grep nginx
amazon-linux-extras enable nginx1
yum clean metadata
yum -y install nginx
nginx -v
echo -E '<!DOCTYPE html><html><head><META HTTP-EQUIV="Content-Type"CONTENT="text/html;charset=UTF8"><title>Andersen DevOps cource: task_08</title><style type= "text/css"></style> </head><script type= "text/javascript" language="JavaScript"> </script><body><h1>task_08</h1>It is terraform script webpage (1st instance).</body></html>' > /usr/share/nginx/html/index.html
systemctl enable nginx.service
systemctl start nginx.service
EOF

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
    description = "Allow http incoming traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # pv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  ingress {
    description = "Allow https incoming traffic"
    from_port   = 443
    to_port     = 443
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
