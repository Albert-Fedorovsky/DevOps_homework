# ------------------------------------------------------------------------------
# Andersen DevOps cource exam
# Terraform template for AWS infrastructure
# Provision Highly Availabe Web in any Region
# Resouces:
#   Network Layer:
#     - VPC - 1 item
#     - Internet Gateway - 1 item
#     - RouteTables - 1 item
#     - Subnets - 2 items
#   Securitty:
#     - Security grops - 1 item
#     - IAM role - 1 item
#   Resouces:#
#     - Custom scripts to create initialize instances.
#     - Autoscaling group with one EC2 instances - 1 item
#     - Application loadbalancer - 1 item
# ------------------------------------------------------------------------------

# ----------------------------- Common data ------------------------------------
# https://awsregion.info/
provider "aws" {
  region = var.region
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones
data "aws_availability_zones" "available" {}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity
data "aws_caller_identity" "current" {}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region
data "aws_region" "current" {}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
data "aws_ami" "latest_ubuntu_20" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
data "aws_ami" "my_jenkins_on_ubuntu_20" {
  owners      = ["854621685927"]
  most_recent = true
  filter {
    name   = "name"
    values = ["Jenkins-on-Ubuntu-20-version-*"]
  }
}
# ------------------------------------------------------------------------------

# ------------------------------- Network --------------------------------------
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "main" {
  # depends_on       = [null_resource.index_html_create]
  cidr_block       = var.main_vpc_cidr_block
  instance_tenancy = "default"

  tags = merge(
    { Name = "Main VPC" },
    var.common_tags,
    { Region = var.region }
  )
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    { Name = "Main gateway" },
    var.common_tags,
    { Region = var.region }
  )
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "for_public_subnets" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(
    { Name = "Route table for public subnets" },
    var.common_tags,
    { Region = var.region }
  )
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_a_cidr_block
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = merge(
    { Name = "Public subnet a" },
    var.common_tags,
    { Region = var.region }
  )
}
resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_b_cidr_block
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = merge(
    { Name = "Public subnet b" },
    var.common_tags,
    { Region = var.region }
  )
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.for_public_subnets.id
}
resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.for_public_subnets.id
}
# ------------------------------------------------------------------------------

# ------------------------------- Security -------------------------------------
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "main" {
  name   = "Main-SG"
  vpc_id = aws_vpc.main.id

  dynamic "ingress" {
    # for_each = ["22", "80", "443"]
    for_each = var.main_sg_allow_ports
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
  }
  tags = merge(
    { Name = "Dynamic SecurityGroup" },
    var.common_tags,
    { Region = var.region }
  )
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile
resource "aws_iam_instance_profile" "jenkins" {
  name = "jenkins-profile"
  role = aws_iam_role.s3-access.name
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
resource "aws_iam_role" "s3-access" {
  name = "s3-access-role"
  #assume_role_policy  = data.aws_iam_policy_document.instance_assume_role_policy.json # (not shown)
  # managed_policy_arns = [aws_iam_policy.policy_one.arn, aws_iam_policy.policy_two.arn]
  managed_policy_arns = [aws_iam_policy.root.arn]
  path                = "/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy
resource "aws_iam_policy" "root" {
  name = "policy-618033"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["*"]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
# ------------------------------------------------------------------------------

# -------------------------- Launch instances ----------------------------------
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration
resource "aws_launch_configuration" "jenkins" {
  name_prefix = "Jenkins-LC-${var.common_tags.Project}-"
  # name                        = "LC-${var.common_tags.Project}-"
  # image_id = data.aws_ami.latest_ubuntu_20.id
  image_id = data.aws_ami.my_jenkins_on_ubuntu_20.id
  root_block_device {
    volume_size = "12"
  }
  instance_type               = var.instance_type
  key_name                    = var.instance_key_name
  iam_instance_profile        = aws_iam_instance_profile.jenkins.id
  associate_public_ip_address = var.instance_public_ip_enable
  security_groups             = [aws_security_group.main.id]
  # user_data = templatefile("user-data-jenkins-on-ubuntu-20.sh.tpl", {
  #   f_name = "Albert",
  #   l_name = "Fedorovsky",
  #   instance_parameters = {
  #     Instance-type = "${var.instance_type}"
  #     Image-name    = "${data.aws_ami.latest_amazon_linux.name}"
  #     Image-id      = "${data.aws_ami.latest_amazon_linux.id}"
  #   },
  #   common_tags = var.common_tags,
  #   region      = var.region,
  #   project     = var.common_tags.Project
  # })
  lifecycle {
    create_before_destroy = true
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group
# https://coderoad.ru/62558731/%D0%9F%D1%80%D0%B8%D1%81%D0%BE%D0%B5%D0%B4%D0%B8%D0%BD%D0%B5%D0%BD%D0%B8%D0%B5-Application-Load-Balancer-%D0%BA-Auto-Scaling-Group-%D0%B2-Terraform-%D0%B4%D0%B0%D0%B5%D1%82
resource "aws_autoscaling_group" "jenkins" {
  name = "Jenkins-ASG-${aws_launch_configuration.jenkins.name}"
  # name_prefix = "ASG-${var.common_tags.Project}-"
  # name     = "ASG-${var.common_tags.Project}-"
  min_size = 1
  max_size = 1
  # min_elb_capacity          = 2 # That parameter broke app loadbalancer!
  health_check_grace_period = 60
  health_check_type         = "ELB"
  desired_capacity          = 1
  # force_delete         = true
  launch_configuration = aws_launch_configuration.jenkins.name
  vpc_zone_identifier  = [aws_subnet.public_a.id, aws_subnet.public_b.id]
  dynamic "tag" {
    for_each = {
      Name  = "Jenkins server in autoscaling group"
      Owner = "${var.common_tags.Owner}"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
  lifecycle {
    ignore_changes = [
      enabled_metrics,
      load_balancers,
      suspended_processes,
      target_group_arns,
      termination_policies,
    ]
    create_before_destroy = true
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
resource "aws_lb" "main" {
  name                       = "main-app-lb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.main.id]
  subnets                    = [aws_subnet.public_a.id, aws_subnet.public_b.id]
  enable_deletion_protection = false
  # access_logs {
  #   bucket  = aws_s3_bucket.lb_logs.bucket
  #   prefix  = "test-lb"
  #   enabled = true
  # }
  tags = merge(
    { Name = "main-app-lb" },
    var.common_tags,
    { Region = var.region }
  )
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}
resource "aws_lb_listener" "secondary" {
  load_balancer_arn = aws_lb.main.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.secondary.arn
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
resource "aws_lb_target_group" "main" {
  name = "LB-TG-${var.common_tags.Project}"
  # name     = "LB-TG-task-08"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  health_check {
    enabled             = true
    healthy_threshold   = "3"
    interval            = "30"
    matcher             = "200"
    port                = "80"
    protocol            = "HTTP"
    timeout             = "15"
    unhealthy_threshold = "3"
  }
  deregistration_delay = "20"
}
resource "aws_lb_target_group" "secondary" {
  name = "LB-TG-S-${var.common_tags.Project}"
  # name     = "LB-TG-task-08"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  health_check {
    enabled             = true
    healthy_threshold   = "3"
    interval            = "30"
    matcher             = "200"
    port                = "8080"
    protocol            = "HTTP"
    timeout             = "15"
    unhealthy_threshold = "3"
  }
  deregistration_delay = "20"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment
# resource "aws_autoscaling_attachment" "main" {
#   autoscaling_group_name = aws_autoscaling_group.main.id
#   alb_target_group_arn   = aws_lb_target_group.main.arn
# }

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment
resource "aws_lb_target_group_attachment" "web_server_1" {
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = aws_instance.web_server_1.id
  port             = 80
}
resource "aws_lb_target_group_attachment" "web_server_2" {
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = aws_instance.web_server_2.id
  port             = 80
}
resource "aws_lb_target_group_attachment" "web_server_1_s" {
  target_group_arn = aws_lb_target_group.secondary.arn
  target_id        = aws_instance.web_server_1.id
  port             = 8080
}
resource "aws_lb_target_group_attachment" "web_server_2_s" {
  target_group_arn = aws_lb_target_group.secondary.arn
  target_id        = aws_instance.web_server_2.id
  port             = 8080
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "web_server_1" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.main.id]
  key_name               = var.instance_key_name
  # monitoring                  = var.detailed_monitoring
  associate_public_ip_address = var.instance_public_ip_enable
  subnet_id                   = aws_subnet.public_a.id
  private_ip                  = var.web_server_1_private_ip
  security_groups             = [aws_security_group.main.id]
  user_data = templatefile("user-data-web-server.sh.tpl", {
    f_name = "Albert",
    l_name = "Fedorovsky",
    instance_parameters = {
      Instance-type = "${var.instance_type}"
      Image-name    = "${data.aws_ami.latest_amazon_linux.name}"
      Image-id      = "${data.aws_ami.latest_amazon_linux.id}"
    },
    common_tags = var.common_tags,
    region      = var.region,
    project     = var.common_tags.Project
  })
  tags = merge(
    { Name = "web-server-1" },
    var.common_tags,
    { Region = var.region }
  )
  lifecycle {
    ignore_changes = [
      security_groups,
    ]
  }
}
resource "aws_instance" "web_server_2" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.main.id]
  key_name               = var.instance_key_name
  # monitoring                  = var.detailed_monitoring
  associate_public_ip_address = var.instance_public_ip_enable
  subnet_id                   = aws_subnet.public_b.id
  private_ip                  = var.web_server_2_private_ip
  security_groups             = [aws_security_group.main.id]
  user_data = templatefile("user-data-web-server.sh.tpl", {
    f_name = "Albert",
    l_name = "Fedorovsky",
    instance_parameters = {
      Instance-type = "${var.instance_type}"
      Image-name    = "${data.aws_ami.latest_amazon_linux.name}"
      Image-id      = "${data.aws_ami.latest_amazon_linux.id}"
    },
    common_tags = var.common_tags,
    region      = var.region,
    project     = var.common_tags.Project
  })
  tags = merge(
    { Name = "web-server-2" },
    var.common_tags,
    { Region = var.region }
  )
  lifecycle {
    ignore_changes = [
      security_groups,
    ]
  }
}
# ------------------------------------------------------------------------------
