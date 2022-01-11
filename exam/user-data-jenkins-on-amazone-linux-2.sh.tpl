#!/bin/bash -xe
echo "Terraform Script" > /home/ec2-user/init-info.txt

echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

yum -y update
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum -y upgrade
amazon-linux-extras install epel -y
yum -y install jenkins java-1.8.0-openjdk-devel
systemctl daemon-reload
systemctl start jenkins.service
systemctl enable jenkins.service

yum -y install docker
usermod -a -G docker ec2-user
systemctl start docker.service
systemctl enable docker.service
