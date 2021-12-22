# task_07

#### Работы по седьмому заданию:

**Регистрация в консоли Amazon:**

Прошёл регистрацию на aws.amazon.com

Авторизовался в своей консоли управления на https://console.aws.amazon.com/

В веб интерфесе AWS консоли, в разделе Identity and Access Management (IAM):

- создал группу пользователей (user group) admins, с политикой AdministratorAccess

- создал пользователя (user)  admin1  и добавил его в группу admins для управления инфраструктурой через aws cli

- создал role: Cloudformation_admin с политикой AdministratorAccess для управления инфраструктурой при помощи шаблонов сервиса clouformation

Создал шаблон task_07.yaml для выполнения требований задания на инфраструктуре AWS

*Примечание: для AWS на схеме в задании не хватает модуля "Internet Gateway" для VPC.* 

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



*Описание работы с шаблонами  cloudformation*

*https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-guide.html*

**Проверка шаблонов cloudformation при помощий AWS CLI c Ubuntu_20**

aws cloudformation validate-template --template-body file://./test.yaml



*Операции со стеком при помощи aws cli:*

*https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-using-cli.html*

**Создание стека cloudformation из шаблона task_07.yaml при помощи AWS CLI c Ubuntu_20**

aws cloudformation create-stack --stack-name test --template-body file://./test.yaml 

**Получение описания стека при помощий AWS CLI c Ubuntu_20**

aws cloudformation describe-stacks --stack-name test

**Получение исходного текста шаблона стека при помощий AWS CLI c Ubuntu_20**

aws cloudformation get-template --stack-name test

**Обновление шаблона (внесение изменений в работающий стек)  при помощий AWS CLI c Ubuntu_20**

aws cloudformation deploy --stack-name test --template ./test.yaml

**Остановка и удаление работающего стека при помощий AWS CLI c Ubuntu_20**

aws cloudformation delete-stack --stack-name test



