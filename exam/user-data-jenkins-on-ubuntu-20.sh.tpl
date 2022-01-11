#!/bin/bash -xe
echo "Terraform Script" > /home/ubuntu/init-info.txt

echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

apt-get -y update
apt-get -y install openjdk-8-jre
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]  https://pkg.jenkins.io/debian-stable binary/ | sudo tee  /etc/apt/sources.list.d/jenkins.list > /dev/null
apt-get -y update
apt-get -y install jenkins
systemctl start jenkins.service
systemctl enable jenkins.service

apt-get install docker.io
usermod -a -G docker ubuntu
systemctl start docker.service
systemctl enable docker.service
