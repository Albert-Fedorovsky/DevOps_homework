variable "region" {
  description = "Please enter AWS region name to deploy web server"
  type        = string
  default     = "eu-central-1"
}

variable "instance_type" {
  description = "Please enter instance type to deploy web server."
  type        = string
  default     = "t2.micro"
}

variable "allow_ports" {
  description = "List of port to open for web server."
  type        = list(any)
  default     = ["22", "80", "443"]
}

variable "detailed_monitoring" {
  description = "Enable detailed monitoring for instances (true | false)."
  type        = bool
  default     = false
}

variable "common_tags" {
  description = "Common Tags to apply all Resources"
  type        = map(any)
  default = {
    Owner       = "Albert Fedorovsky",
    Project     = "Lesson-12",
    Costcenter  = "12345",
    Environment = "development"
  }
}
