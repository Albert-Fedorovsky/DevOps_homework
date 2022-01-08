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
Andersen DevOps cource: ${project}
</title>
<style type= "text/css">
</style>
</head>
<script type= "text/javascript" language="JavaScript">
</script>
<body>
<h1>
${project}
</h1>
<font color="DarkBlue">
This is the EC2 instance made by ${f_name} ${l_name} template script for ${project}.<br>
%{ for x, y in instance_parameters ~}
${x}: ${y}<br>
%{ endfor ~}
%{ for x, y in common_tags ~}
${x}: ${y}<br>
%{ endfor ~}
Region: ${region}<br>
</body>
</html>
EOF

aws s3 cp s3://${project}/index.html /var/www/html/index.html

cat <<EOF >> /var/www/html/index.html
<html>
<body>
<font color="Green">
Instance local IP: $myip<br>
</body>
</html>
EOF

systemctl start httpd.service
systemctl enable httpd.service
