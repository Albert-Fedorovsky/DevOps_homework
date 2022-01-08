output "latest_ubuntu_20_ami_id" {
  value = data.aws_ami.latest_ubuntu_20.id
}

output "latest_ubuntu_20_ami_name" {
  value = data.aws_ami.latest_ubuntu_20.name
}

output "latest_amazon_linux_ami_id" {
  value = data.aws_ami.latest_amazon_linux.id
}

output "latest_amazon_linux_ami_name" {
  value = data.aws_ami.latest_amazon_linux.name
}

output "latest_windows_server_2019_ami_id" {
  value = data.aws_ami.latest_windows_server_2019.id
}

output "latest_windows_server_2019_ami_name" {
  value = data.aws_ami.latest_windows_server_2019.name
}
