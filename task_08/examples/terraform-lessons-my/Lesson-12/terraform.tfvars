# Auto fill variables for production
# https://www.terraform.io/language/values/variables
# File can nammed as terraform.tfvars or *.auto.tfvars

region              = "us-east-1"
instance_type       = "t3.micro"
detailed_monitoring = true
allow_ports         = ["22", "80", "443", "8080"]
common_tags = {
  Owner       = "Albert Fedorovsky",
  Project     = "Lesson-12",
  Costcenter  = "54321",
  Environment = "prod"
}
