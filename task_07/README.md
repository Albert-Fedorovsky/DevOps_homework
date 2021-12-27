# task-07

#### Работы по седьмому заданию:

**Регистрация в консоли Amazon:**

Прошёл регистрацию на aws.amazon.com

Авторизовался в своей консоли управления на https://console.aws.amazon.com/

В веб интерфесе AWS консоли, в разделе Identity and Access Management (IAM):

- создал группу пользователей (user group) admins, с политикой AdministratorAccess

- создал пользователя (user)  admin1  и добавил его в группу admins для управления инфраструктурой через aws cli

- создал role: Cloudformation_admin с политикой AdministratorAccess для управления инфраструктурой при помощи шаблонов сервиса clouformation

Создал шаблон task-07.yaml для выполнения требований задания на инфраструктуре AWS

*Примечание: для AWS на схеме в задании не хватает модуля "Internet Gateway" для VPC и групп безопастности.* 

**Установка ПО на Windows 10:**

notepad++

Typora

BvSshClient

VMWare Workstation

**Установка виртуальных машин на VMWare Workstation:**

1шт.: "Ubuntu_20" на базе образа "ubuntu-20.04.1-desktop-amd64.iso"

сетевой интерфейс в сконфигурирован как bridge

при установке создан пользователь user

установлен статический IP 192.168.1.99

**Установка ПО на Ubuntu_20:**

sudo apt-get update

sudo apt-get install ssh

sudo apt-get install awscli

sudo apt-get install python3-pip

aws --version

**Конфигурация AWS CLI на Ubuntu_20**

aws configure

AWS Access Key ID [None]:  `<Access key ID>`

AWS Secret Access Key [None]: ` <Secret access key>`

Default region name [None]: `eu-central-1`

Default output format [None]: `json`

**Создание пары ключей RSA для EC2 инстансов при помощи AWS CLI c Ubuntu_20**

aws ec2 create-key-pair --key-name my-new-key-pair

aws ec2 create-key-pair --key-name my-new-key-pair --query "KeyMaterial" --output text > my-new-key-pair.pem

chmod go-rwx my-new-key-pair.pem

**Просмотр перечня пар ключей EC2 инстансов через AWS CLI на Ubuntu_20**

aws ec2 describe-key-pairs 

aws ec2 describe-key-pairs --key-name my-new-key-pair

**Удаление пар ключей EC2 инстансов через AWS CLI на Ubuntu_20**

aws ec2 delete-key-pair --key-name my-new-key-pair

**Создание S3 bucket с именем task-07 при помощий AWS CLI на Ubuntu_20**

*https://docs.aws.amazon.com/cli/latest/reference/s3/*

aws s3 mb s3://task-07

**Управление доступом (ACL) S3 bucket с именем task-07 при помощий AWS CLI на Ubuntu_20**

*https://docs.aws.amazon.com/cli/latest/reference/s3api/*

*https://docs.aws.amazon.com/cli/latest/reference/s3api/put-bucket-acl.html*

aws s3api put-bucket-acl --bucket task-07 --grant-read uri=http://acs.amazonaws.com/groups/global/AllUsers

**Загрузка файла index.html на S3 bucket с именем task-07 при помощий AWS CLI на Ubuntu_20**


aws s3 cp index.html s3://task-07/index.html


**Получение файла index.html из S3 bucket с именем task-07 AWS CLI на Amazon Linux 2 AMI** 

aws s3 cp s3://task-07/index.html /usr/share/nginx/html/

**Получение перечня запущенных S3 buckets при помощий AWS CLI c Ubuntu_20**

aws s3 ls

**Удаление файла index.html на S3 bucket с именем task-07 при помощий AWS CLI на Ubuntu_20**

aws s3 rm s3://task-07/index.html

**Удаление S3 bucket с именем task-07 при помощий AWS CLI на Ubuntu_20**

aws s3 rb s3://task-07

**Подключение к Ubuntu Server 20.04 LTS (HVM) инстансу по SSH на Ubuntu_20**

chmod go-rwx ./instance_key_pair.pem

ssh -i ./instance_key_pair.pem ubuntu@<instance public IP>

**Подключение к Amazon Linux 2 AMI (HVM) инстансу по SSH на Ubuntu_20**

chmod go-rwx ./instance_key_pair.pem

ssh -i ./instance_key_pair.pem ec2-user@<instance public IP>

**Копирование файлов в папку пользователя по умолчанию на Amazon Linux 2 AMI (HVM) инстанс по SSH на Ubuntu_20**

scp -i ./instance_key_pair.pem ./file.txt ec2-user@<instance public IP>:/home/ec2-user/

**Проверка шаблонов cloudformation при помощий AWS CLI c Ubuntu_20**

*Описание работы с шаблонами  cloudformation*

*https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-guide.html*

aws cloudformation validate-template --template-body file://./task-07.yaml

**Создание стека cloudformation из шаблона task-07.yaml при помощи AWS CLI c Ubuntu_20**

*Операции со стеком при помощи aws cli:*

*https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-using-cli.html*

aws cloudformation create-stack --stack-name task-07 --template-body file://./task-07.yaml --capabilities CAPABILITY_IAM

**Получение описания стека при помощий AWS CLI c Ubuntu_20**

aws cloudformation describe-stacks --stack-name task-07

**Получение исходного текста шаблона стека при помощий AWS CLI c Ubuntu_20**

aws cloudformation get-template --stack-name task-07

**Обновление шаблона (внесение изменений в работающий стек)  при помощий AWS CLI c Ubuntu_20**

aws cloudformation deploy --stack-name task-07 --template ./task-07.yaml --capabilities CAPABILITY_IAM

**Остановка и удаление работающего стека при помощий AWS CLI c Ubuntu_20**

aws cloudformation delete-stack --stack-name task-07

**Получение информации по запущенным EC2 инстансам при помощий AWS CLI c Ubuntu_20**

*https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-instances.html*

aws ec2 describe-instances 

aws ec2 describe-instances  --filters Name=instance-type,Values=t2.micro | grep PublicIpAddress

**Конфигурация NGINX на EC2 инстансе**

*https://codex.so/devops-basics*

sudo nano /etc/nginx/nginx.conf

В файле /etc/nginx/nginx.conf: 

listen 80 — какой порт будет «слушать» сервер

server_name yourdomain.com — доменное имя сервера

root /usr/share/nginx/html — директория, в которой будут лежать файлы проекта

sudo systemctl enable nginx.service

sudo systemctl start nginx.service

sudo systemctl status nginx.service
