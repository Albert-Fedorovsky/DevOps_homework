# task_07

#### Работы по седьмому заданию:

**Регистрация в консоли Amazon:**

Прошёл регистрацию на aws.amazon.com

Авторизовался в своей консоли управления на https://console.aws.amazon.com/

Создал нового пользователя (Security credentials - Users - Add users) user1 с правами доступа [AdministratorAccess]

Загрузил new_user_credentials.csv для user1

**Регистрация на Microsoft Azure:**

Прошёл регистрацию на azure.com

Авторизовался в своей консоли управления на https://portal.azure.com

**Создание вирутальной машины через консоль AWS:**

Zone: Europe (Frankfurt) eu-central-1

EC2 - EC2 Dashboard - Launch instance

*Choose AMI:* Ubuntu Server 20.04 LTS (HVM), SSD Volume Type - ami-0a49b025fffbbdac6 (64-bit x86)

*Choose Instance Type:* Family: t2	Type: t2.micro	vCPUs: 1	Memory (GiB): 1	Instatnce storage (GB): ESB only	EBS-Optimized Avalibale: - Network Performance:  Low to modarete	IPv6 Support: yes

*Add Storage:* Size (Gib) 12

*Configure Security Group:* Type: SSH	Protocol: TCP	Port Range: 22	Source: Custom 0.0.0.0/0

Создал и загрузил файл с новой парой ключей rsa: ./instance1_key_pair.pem

**Регистрация на Microsoft Azure:**

Прошёл регистрацию на portal.azure.com

Авторизовался через свою учётную запись.

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

sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg

curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null

AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | sudo tee /etc/apt/sources.list.d/azure-cli.list

sudo apt-get update

sudo apt-get install azure-cli

**Размещение приватных данных при помощи Azure CLI на Ubuntu_20**

az login

*Просмотрел перечень локаций серверов Azure:*

az account list-locations

*Создал группу ресурсов:*

az group create --name "AWS_EC2" -l "swedencentral"

*Создал хранилище ключей (группа ресурсов AWS_EC2, key-storage-1).*

az keyvault create --name "key-storage-1" --resource-group "AWS_EC2" --location "swedencentral"

*Разместил приватные данные из new_user_credentials.csv для user1 в хранилище секретов.* 

az keyvault secret set --vault-name "key-storage-1" --name "AWS-User1-Access-key-ID" --value "<Access key ID>"

az keyvault secret set --vault-name "key-storage-1" --name "AWS-User1-Secret-access-key" --value "<Secret access key>"

az keyvault secret set --vault-name "key-storage-1" --name "AWS-User1-Console-login-link" --value "<Console login link>"

**Получение данных из Azure Key Vault на Ubuntu_20**

az keyvault secret show --vault-name "key-storage-1" --name "AWS-User1-Access-key-ID" --query "value"

az keyvault secret show --vault-name "key-storage-1" --name "AWS-User1-Secret-access-key" --query "value"

az keyvault secret show --vault-name "key-storage-1" --name "AWS-User1-Console-login-link" --query "value"

**Удаление группы ресурсов Azure на Ubuntu_20**

az group delete --name "myResourceGroup"

**Конфигурация AWS CLI на Ubuntu_20**

aws configure

AWS Access Key ID [None]:  `<Access key ID>`

AWS Secret Access Key [None]: ` <Secret access key>`

Default region name [None]: `eu-central-1`

Default output format [None]: `json`

**Создание пары ключей при помощи AWS CLI на Ubuntu_20**


aws ec2 create-key-pair --key-name MyKeyPair

**Создание пары ключей сторонним инструментом и импорт новой пары ключей для ec2 инстансов через AWS CLI на Ubuntu_20**

ssh-keygen -t rsa -C "my-key" -f ./my-key

aws ec2 import-key-pair --key-name "my-key" --public-key-material fileb://~/.ssh/my-key.pub

**Просмотр перечня пар ключей ec2 инстансов через AWS CLI на Ubuntu_20**

aws ec2 describe-key-pairs 

aws ec2 describe-key-pairs --key-name instance1_key_pair

**Удаление пар ключей ec2 инстансов через AWS CLI на Ubuntu_20**

aws ec2 delete-key-pair --key-name MyKeyPair

aws ec2 delete-key-pair --key-name my-key

**Подключение к инстансу ami-0a49b025fffbbdac6 (64-bit x86) по SSH на на Ubuntu_20**

chmod go-rwx ./instance1_key_pair.pem

ssh -i ./instance1_key_pair.pem ubuntu@18.195.191.206

