#!/bin/bash -xe
echo "Terraform Script" > /home/ec2-user/init-info.txt
yum update -y
yum install -y httpd.x86_64

myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

cat <<EOF > /var/www/html/index.html
<html>
<h2>Build by Power of <font color="red"> Terraform </font></h2><br>
Owner ${f_name} ${l_name}<br>

%{ for x in names ~}
Hello to ${x} from ${f_name}<br>
%{ endfor ~}

</html>
EOF

systemctl start httpd.service
systemctl enable httpd.service
