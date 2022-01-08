#!/bin/bash -xe
echo "Terraform Script" > /home/ec2-user/init-info.txt
yum -y update
yum -y install httpd.x86_64

myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
<META HTTP-EQUIV="Content-Type"CONTENT="text/html;charset=UTF8">
<title>
Andersen DevOps cource: task_08
</title>
<style type= "text/css">
</style>
</head>
<script type= "text/javascript" language="JavaScript">
</script>
<body>
<h1>
task_08
</h1>
<font color="DarkBlue">
This is the EC2 instance made by Albert Fedorovsky script for task_08.<br>
Version: 1.0<br>
Instance local IP: $myip
</body>
</html>
EOF

systemctl start httpd.service
systemctl enable httpd.service
