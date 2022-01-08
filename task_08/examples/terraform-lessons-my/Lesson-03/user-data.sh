#!/bin/bash -xe
echo "Terraform Script" > /home/ec2-user/init-info.txt
yum update -y
amazon-linux-extras list | grep nginx
amazon-linux-extras enable nginx1
yum clean metadata
yum -y install nginx
nginx -v
echo -E '<!DOCTYPE html><html><head><META HTTP-EQUIV="Content-Type"CONTENT="text/html;charset=UTF8"><title>Andersen DevOps cource: task_08</title><style type= "text/css"></style> </head><script type= "text/javascript" language="JavaScript"> </script><body><h1>task_08</h1><br><font color="blue">It is terraform using user external script webpage (1st instance).</body></html>' > /usr/share/nginx/html/index.html
systemctl enable nginx.service
systemctl start nginx.service
