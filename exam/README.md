# exam

## **Работы по экзаменационному заданию:**

### Установка ПО и базовые настройки

**Регистрация в консоли Amazon:**

Прошёл регистрацию на aws.amazon.com

Авторизовался в своей консоли управления на https://console.aws.amazon.com/

В веб интерфейсе AWS консоли, в разделе Identity and Access Management (IAM):

- создал группу пользователей (user group) admins, с политикой AdministratorAccess
- создал пользователя (user) admin1 и добавил его в группу admins для управления инфраструктурой через aws cli

**Создание новых репозиториев на Github:**

Создал два новых репозитория: https://github.com/Albert-Fedorovsky/exam-python-app и https://github.com/Albert-Fedorovsky/exam-go-app  для хранения исходных кодов веб приложений.

**Создание новой пар ключей для доступа к Github репозиторию:**

Генерация пары ключей (в консоли git bash):

*https://hyperhost.ua/info/ru/generatsiya-i-dobavleniya-ssh-klyucha-dlya-podklyucheniya-k-udalennomu-repozitoriyu-github*

ssh-keygen -t rsa -b 4096 -C "alb271@yandex.ru" -f exam-python-app.key

ssh-keygen -t rsa -b 4096 -C "alb271@yandex.ru" -f exam-go-app.key

*.key - приватный ключ (подключается к Jenkins)

*.key.pub - публичный ключ (подключается к репозиторию на Github)

Подключение публичного ключа к репозиторию:

*https://docs.github.com/en/developers/overview/managing-deploy-keys#deploy-keys*

**Клонирование новых репозиториев:**

git clone git@github.com:Albert-Fedorovsky/exam-python-app.git

git clone git@github.com:Albert-Fedorovsky/exam-go-app.git

**Зарегистрировался на DockerHub для размещения образов в публичном репозитории**

*Авторизация в репозитории:*

docker login

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

sudo apt-get -y update

sudo apt-get -y install openjdk-8-jre

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

скопировал скрипт из задания 10 и назвл его "snapshots-master.sh"

chmod +x snapshots-master.sh

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



### Работа с terraform

**Создал шаблон terrafom в соответствии с требованиями задания, состоящий из следующих файлов:**

- main.tf - описание основных ресурсов стека
- outputs.tf - описание некоторых параметров ресурсов, печатаемых terraform по завершению создания стека, требующихся для дальнейшей работы со стеком
- variables.tf - описание внешних переменных, используемых при создании стека
- terraform.tfvars - значения, инициализирующие внешние переменные при создании стека
- user-data-jenkins-on-amazone-linux-2.sh.tpl - скрипт делающий начальную конфигурацию Jenkins сервера на базе amazone-linux-2 
- user-data-jenkins-on-ubuntu-20.sh.tpl - скрипт делающий начальную конфигурацию Jenkins сервера на базе ubuntu-20 
- user-data-web-server.sh.tpl - - скрипт делающий начальную конфигурацию web серверов на базе amazone-linux-2

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



### Работа с серверами в облаке Amazone:

#### Работа с EC2 инстансами

**Информация по дисковому пространству**

*https://www.hostinger.ru/rukovodstva/kak-uznat-svobodnoe-mesto-na-diske-v-linux*

df -h

**Посмотреть открытые порты**

netstat -pnltu

**Установка Jenkins на Jenkins-server c Ubuntu-20**

https://pkg.jenkins.io/debian-stable/

apt-get -y update

apt-get -y install openjdk-8-jre

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-

keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]  https://pkg.jenkins.io/debian-stable binary/ | sudo tee  /etc/apt/sources.list.d/jenkins.list > /dev/null

apt-get -y update

apt-get -y install jenkins

systemctl start jenkins.service

systemctl enable jenkins.service

systemctl status jenkins.service

sudo su

echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

**Установка Jenkins на Webserver c Amazon-Linux-2**

*https://www.jenkins.io/doc/tutorials/tutorial-for-installing-jenkins-on-AWS/#install-and-configure-jenkins*

*https://stackoverflow.com/questions/68806741/how-to-fix-yum-update-of-jenkins*

yum -y update

wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo

rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

yum -y upgrade

amazon-linux-extras install epel -y

yum -y install jenkins java-1.8.0-openjdk-devel

systemctl daemon-reload

systemctl start jenkins.service

systemctl enable jenkins.service

systemctl status jenkins.service



#### Работа с Jenkins

**Разблокировать пароль администратора Jenkins**

*Получить пароль*

sudo cat /var/lib/jenkins/secrets/initialAdminPassword

Ввести полученный пароль на вестранице Jenkins (она работает на порте :8080)

После установки необходимых плагинов создать нового администратора и пароль для него

**Инсталлировать необходимые плагины на Jenkins-server**

все рекомендуемые плагины, а также:

Publish Over SSH - добавляет опцию отправки файлов по SSH

**Установка английского языка по умолчанию:**

Нажмите « **Управление Jenkins»> «Управление плагинами»> [вкладка «Доступно»]**

В фильтре найдите: *Locale* .

Установите флажок « **Locale Plugin»** и **установите без перезагрузки** .

После завершения установки:

- В разделе **«Управление Jenkins> Конфигурация системы»** должен быть раздел « *Locale* ».
- Введите код *language_LOCALE* по умолчанию для английского языка: **en_US**
- Установите галочку «*Ignore browser preference and force this language to all users*»

**Настройка deployment серверов для плагина Publish Over SSH на Jenkins-server**

В разделе Dashboard -> configuration -> Publish over SSH

- вставить RSA Key
- в подразделе SSH Servers нажать кнопку "add" и заполнить поля для каждого сервера
- Name = web-server-1 и web-server-2
- Hostname = 10.0.10.10 - для webserver 1 и 10.0.20.10 - для webserver 2
- Username = ec2-user (для amazone linux)
- Remote Directory = /var/www/html/ (для apache)
- нажать кнопку save

**Создание нового пользователя для администрирования Jenkins**

В разделе Dashboard -> Manage Jenkins -> Manage users -> Create User

создать пользователя

сделать релог в UI вновь созданным пользователем

В разделе Dashboard -> Manage Jenkins -> Manage users -> <username>

API Token -> Add new Token - скопировать и сохранить токен в файл

**Получение jenkins-cli.jar файла на Ubuntu_20**

wget http://52.59.228.40:8080/jnlpJars/jenkins-cli.jar

**Экспорт секретных данных  Jenkins в переменные окружения на Ubuntu_20**

export JENKINS_USER_ID=myserviceuser

export JENKINS_API_TOKEN=`cat ~/Downloads/Jenkins-myserviceuser-token-1.key`

env | grep JENKINS

**Отправка команды jenkins серверу при помощи CLI с Ubuntu_20**

java -jar jenkins-cli.jar -auth <username>:<password> -s http://52.59.228.40:8080 who-am-i

*или с использованием токена:*

java -jar jenkins-cli.jar -auth myserviceuser:`cat ~/Downloads/Jenkins-myserviceuser-token-1.key` -s http://52.59.228.40:8080 who-am-i

*или с использованием переменных окружения с записаным токеном:*

java -jar jenkins-cli.jar -s http://52.59.228.40:8080 who-am-i

**Просмотр перечня команд jenkins сервера**

Страница с командами в UI: Dashboard -> Manage Jenkins -> Jenkins CLI

**Сохранение описания созданной на Jenkins сервере задачи в .xml файл на Ubuntu_20:**

java -jar jenkins-cli.jar -s http://52.59.228.40:8080 get-job deploy-to-web-server-1 > deploy-to-web-server-1.xml

**Выгрузка из файла в .xml формате описания  задачи на Jenkins сервер с Ubuntu_20:**

java -jar jenkins-cli.jar -s http://52.59.228.40:8080 create-job deploy-to-web-server-1-new < deploy-to-web-server-1.xml



#### Создание образов сконфигурированного сервера Jenkins

**Получение информации о пользователе AWS CLI c Ubuntu_20**

aws iam get-user

**Получение информации по запущенным EC2 инстансам при помощий AWS CLI c Ubuntu_20**

*https://docs.aws.amazon.com/cli/latest/reference/ec2/*

aws ec2 describe-instances 

aws ec2 describe-instances  --filters Name=instance-type,Values=t2.micro | grep PublicIpAddress

**Просмотр параметров запущенных EC2 инстансов при помощи AWS CLI c Ubuntu_20**

*https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/index.html*

aws ec2 describe-instances | grep InstanceId

aws ec2 describe-volumes | grep VolumeId

**Создание EBS snapshot при помощи AWS CLI c Ubuntu_20**

*https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/create-snapshot.html*

aws ec2 create-snapshot --volume-id vol-0a2a98edbbd08c352 --description "This is my Jenkins root volume snapshot 1"

**Получение списка EBS snapshot c отображением давности создания, идентификатора снимков и их описаний при snapshot-master.sh c Ubuntu_20**

./snapshots-master.sh Age SnapshotId Description

*Отобразить только снимок, имеющий в поле Description подстроку "snapshot 1"*

./snapshots-master.sh Age SnapshotId Description  --filter "snapshot 1"

**Копирование EBS snapshot в S3 при помощи snapshot-master.sh c Ubuntu_20**

./snapshots-master.sh Age SnapshotId Description  --filter "snapshot 1" --snapshots-action copy

**Удаление EBS snapshot при помощи snapshot-master.sh c Ubuntu_20**

./snapshots-master.sh Age SnapshotId Description  --filter "Copy of: This is my Jenkins root volume snapshot 1" --snapshots-action delete

**Создание AMI из EBS snapshot при помощи AWS CLI c Ubuntu_20**

https://docs.aws.amazon.com/cli/latest/reference/ec2/register-image.html

aws ec2 register-image --name "Jenkins-on-Ubuntu-20-version-001" --description "This is my Jenkins on Ubuntu 20" --block-device-mappings DeviceName="/dev/sda",Ebs={SnapshotId="snap-0f85d524807b23863"} --root-device-name "/dev/sda1"

**Создание AMI из EC2 instance при помощи AWS CLI c Ubuntu_20**

aws ec2 create-image --name "Jenkins-on-Ubuntu-20-version-004" --description "This is my Jenkins on Ubuntu 20" --instance-id i-0e42ec3c681ca522f

**Получение описания имеющихся AMI images при помощи AWS CLI c Ubuntu_20**


aws ec2 describe-images --owners self

**Удаление AMI при помощи AWS CLI c Ubuntu_20**

aws ec2 deregister-image --image-id ami-0e2f98f2e23147735



#### Работа с Docker

*https://habr.com/ru/company/flant/blog/336654/*

*https://qastack.ru/programming/23735149/what-is-the-difference-between-a-docker-image-and-a-container*

**Установка Docker на Jenkins сервер с Ubuntu_20:**

sudo apt-get update

sudo apt-get install docker.io

*сделать релог*

sudo docker login

**Установка Docker на web server с Amazone Linux 2:**

sudo  yum -y install docker

sudo usermod -a -G docker ec2-user

sudo systemctl start docker.service

sudo systemctl enable docker.service

*сделать релог*

**Сборка изображения docker по рецепту, находящемуся в текущей директории:**

sudo docker build -t alb271/python_app .

**Создание именованного изображения Docker из изображения **

sudo  docker tag <image name or ID> <dockerhub account name>/<image name>:<version or tag>

sudo docker tag 0a1b4c63b0be alb271/python_app

**Создание именованного изображения Docker из контейнера**

sudo  docker commit <container name> <dockerhub account name>/<image name>:<version or tag>

**Подключение к Dockerhub репозиторию**

docker  login 

**Отключение от Dockerhub репозитория**

docker logout

**Размещение именованного контейнера Docker на Dockerhub**

*https://dker.ru/docs/docker-engine/learn-by-example/store-images-on-docker-hub/*

*https://dker.ru/docs/docker-engine/learn-by-example/build-your-own-images/*

sudo docker push alb271/python_app

**Получение именованного контейнера из Dockerhub**

sudo docker pull alb271/python_app

**Запуск контейнера docker:**

*Запуск с входом в контейнер (для отладки):*

sudo docker run -it alb271/python_app sh

*Запуск контейнера в фоне (боевой):*

sudo docker run -d -p 80:5000 alb271/python_app 

*Отладка запущенного в фоне контейнера:*

sudo docker ps

sudo docker exec -i -t <ID> sh

**Вывод списка запущенных контейнеров docker**

sudo docker ps

**Вывод списка, всех (запущенных и нет) имеющихся на локальной машине контейнеров**

sudo docker container ls -a

**Вывод списка имеющихся на локальной машине изображений**

sudo docker images

sudo docker images --digests

**Остановка контейнера:**

sudo docker stop <ID>

docker kill $(docker ps -q) - останавливает все контейнеры

**Остановка контейнера с известным именем образа:**

sudo docker stop $(docker ps -aq --filter ancestor=alb271/python_app)

**Удаление удаление изображений:**

sudo docker rmi <ID> -f

sudo docker rmi $(docker images -q alb271/python_app)  - удалить изображения конкретного репозитория

sudo docker rmi $(docker images -q) -f - удалить все изображения

**Удаление остановленных контейнеров:**

sudo docker rm <ID>

sudo docker rm $(docker container ls -aq) - удалить все контейнеры

**Удаление остановленных контейнеров c известным именем образа**

sudo docker rm $(docker container ls -aq --filter ancestor=alb271/python_app)



### Разработка веб приложений

**Создал два идентичных веб приложения, в соответствии с тебованиями задания, состоящие из следующих файлов:**

#### python-app ("Hello world 1")

main.py - интерпретируемый файл приложения Python

Dockerfile - рецепт сборки изображения докера с приложением, на базе Alpian Linux

jenkins-buld-pytnon-app.sh - содержит скрипты для сборки и доставки приложения на веб серверы (используется для настройки Jenkins через UI)

launch-pytnon-app.sh - скрипт осуществляющий развёртывание приложения на веб сервере (доставляется непосредственно на веб сервер и запускается на исполнение)

#### go-app ("Hello world 2")

main.go - исходный файл приложения, компилируемый при помощи Golang

Dockerfile - рецепт сборки изображения докера с приложением, на базе Alpian Linux

jenkins-buld-pytnon-app.sh - содержит скрипты для сборки и доставки приложения на веб серверы (используется для настройки Jenkins через UI)

launch-pytnon-app.sh - скрипт осуществляющий развёртывание приложения на сервере (доставляется непосредственно на веб сервер и запускается на исполнение)



#### Разработка  диаграмм для презентации проекта

**Примеры диаграмм**

*https://online.visual-paradigm.com/diagrams/templates/aws-architecture-diagram/confluence-data-center/*

Создал две диаграммы, демонстирующие CI CD и инфраструктуру:

- Implemented-CI-CD  в форматах *.vsdx (MS Visio) и *.pdf - демонстрирует процесс CI CD продукта
- infrastructure-diagram в форматах *.vpd (сервис https://online.visual-paradigm.com/) и *.pdf - демонстрирует инфраструктуру в облаке AWS, описанную в проекте terrafom

