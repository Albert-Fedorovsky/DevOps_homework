#!/bin/bash -xe
echo "Terraform Script" > /home/ec2-user/init-info.txt

yum -y update
yum -y install docker
usermod -a -G docker ec2-user
systemctl start docker.service
systemctl enable docker.service

docker pull alb271/python_app
docker run -d -p 80:5000 alb271/python_app
docker pull alb271/go_app
docker run -d -p 8080:8181 alb271/go_app
