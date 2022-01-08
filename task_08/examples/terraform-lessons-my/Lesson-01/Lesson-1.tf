# На основе https://github.com/adv4000/terraform-lessons

provider "aws" {
  region = "eu-central-1"
}

# resource "aws_instance" "my_Ubuntu" {
#   ami           = "ami-0d527b8c289b4af7f"
#   instance_type = "t2.micro"
#   tags = {
#     Name    = "My Amazone server"
#     Owner   = "Albert Fedorovsky"
#     Project = "Terraform lessons"
#   }
# }

resource "aws_instance" "my_Amazone_linux" {
  count         = 1
  ami           = "ami-05d34d340fb1d89e5"
  instance_type = "t2.micro"
  tags = {
    Name    = "My Amazone server"
    Owner   = "Albert Fedorovsky"
    Project = "Terraform lessons"
  }
}
