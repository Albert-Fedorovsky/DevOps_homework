#!/bin/bash -xe

cat <<EOF > index.html
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

cat <<EOF >> index.html
<html>
<body>
<font color="Green">
File from ${project} S3 bucket!<br>
</body>
</html>
EOF

aws s3 cp index.html s3://${project}/index.html
rm index.html
