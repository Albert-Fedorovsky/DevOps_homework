## **task-08**

**Работы по восьмому заданию:**

**Регистрация в консоли Amazon:**

Прошёл регистрацию на aws.amazon.com

Авторизовался в своей консоли управления на https://console.aws.amazon.com/

В веб интерфейсе AWS консоли, в разделе Identity and Access Management (IAM):

·    создал группу пользователей (user group) admins, с политикой AdministratorAccess

·    создал пользователя (user) admin1 и добавил его в группу admins для управления инфраструктурой через aws cli

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

*Установка или обновление terraform*

на сайте terraform в раздел загрузок https://www.terraform.io/downloads и копируем ссылку на нужную версию (linux amd64)

wget https://releases.hashicorp.com/terraform/1.1.2/terraform_1.1.2_linux_amd64.zip

unzip terraform_1.1.2_linux_amd64.zip

sudo mv terraform /bin/

terraform --version

*Установка и настройка текстового редактора Atom*

на сайте atom в раздел руководства по установке https://flight-manual.atom.io/getting-started/sections/installing-atom/ получаем инструкции по установке

wget -qO - https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add -

sudo sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'

sudo apt-get update

sudo apt-get install atom

Запустить terraform

Перейти в edit -> prefences -> install

Через поиск найти и установить laungage-terraform и terraform-fmt

Перейти в edit -> prefences -> themes -> ui theme -> шестерёнка и установить более купный font size

Перейти в file -> add project folder и установить папку проекта

**Конфигурация AWS CLI на Ubuntu_20**

aws configure

AWS Access Key ID [None]: <Access key ID>

AWS Secret Access Key [None]: <Secret access key>

Default region name [None]: eu-central-1

Default output format [None]: json

**Создание** **пары** **ключей** **RSA** **для** **EC2** **инстансов** **при** **помощи** **AWS CLI c Ubuntu_20**

aws ec2 create-key-pair --key-name my-new-key-pair

aws ec2 create-key-pair --key-name my-new-key-pair --query "KeyMaterial" --output text > my-new-key-pair.pem

chmod go-rwx my-new-key-pair.pem

**Просмотр перечня пар ключей EC2 инстансов через AWS CLI на Ubuntu_20\****

aws ec2 describe-key-pairs 

aws ec2 describe-key-pairs --key-name my-new-key-pair

**Экспорт в окружение переменных AWS , требующихся для работы terraform на Ubuntu_20**

export AWS_ACCESS_KEY_ID=<Access key ID>

export AWS_SECRET_ACCESS_KEY=<Secret access key>

export AWS_DEFAULT_REGION=eu-central-1

***Создал шаблон terrafom в соответствии с требованиями задания, состоящий из следующих файлов:\***

·    main.tf - описание основных ресурсов стека

·    outputs.tf - описание некоторых параметров ресурсов, печатаемых terraform по завершению создания стека, требующихся для дальнейшей работы со стеком

·    variables.tf - описание внешних переменных, используемых при создании стека

·    terraform.tfvars - значения, инициализирующие внешние переменные при создании стека

*Примечание: для AWS на схеме в задании не хватает модуля "Internet Gateway", групп безопастности, таблиц маршрутизации, "Autoscaling Group".* 

***Дальнейшие действия выполнялись в консоли на виртуальной машине с Ubuntu_20\***

**Инициализация terrafom (подгрузка инструментария в зависимости от кода во всех файлах проекте)** 

*перейти в папку проекта и выполнить*:

terraform init

**Вывод плана проекта terrafom перед его исполнением** 

*План создания:*

terraform plan

*План уничтожения:*

terraform plan -destroy

*План с подстановкой значений переменных отличных от их значений по умолчанию:*

terraform plan -var="region=us-east-1" -var="instance_type=t2.micro"

*Экспорт новых этих переменных в окружение, чтобы не передавать их как параметры*

export TF_VAR_region=us-east-1

echo $TF_VAR_region

export TF_VAR_instance_type=t2.micro

echo $TF_VAR_instance_type

env | grep TF_VAR_

*Использование конкретного внешнего файла со значениями переменных*

terraform plan -var-file="prod.auto.tfvars"

**Создание проекта terrafom на облачной инфраструктуре по плану**

terraform apply

yes

*примечание: создаётся terraform.tfstate - файл с описанием созданной инфраструктуры, используется terraform для внесения изменений в инфраструктуру*

**Удаление проекта terrafom на облачной инфраструктуре AWS по плану**

terraform destroy

yes

**Тестирование** **функций** **terraform**

terraform console

*exit - для выхода*

**Печать определённые в шаблоне выходные данные** 

terraform output

*Примечание: сначала нужно выполнить terraform apply*

**Печать текущего состояния инфраструктуры (из файла .tfstate)** 

terraform show

**Создание графов при помощи terraform:**

*https://runebook.dev/ru/docs/terraform/commands/graph*

sudo apt-get update

sudo apt-get install graphviz

terraform graph | dot -Tsvg > graph.svg

 
