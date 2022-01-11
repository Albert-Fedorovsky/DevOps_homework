#!/bin/bash -xe
echo "Terraform Script" > /home/ec2-user/init-info.txt

yum -y update
yum -y install docker
usermod -a -G docker ec2-user
systemctl start docker.service
systemctl enable docker.service
