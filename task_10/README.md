# task-10

#### Работы по десятому заданию:

**Регистрация в консоли Amazon:**

Прошёл регистрацию на aws.amazon.com

Авторизовался в своей консоли управления на https://console.aws.amazon.com/

В веб интерфесе AWS консоли, в разделе Identity and Access Management (IAM):

- создал группу пользователей (user group) admins, с политикой AdministratorAccess
- создал пользователя (user)  admin1  и добавил его в группу admins для управления инфраструктурой через aws cli

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

**Просмотр параметров запущенных EC2 инстансов при помощи AWS CLI c Ubuntu_20**

*https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/index.html*

aws ec2 describe-instances | grep InstanceId

aws ec2 describe-volumes | grep VolumeId

**Создание EBS snapshot при помощи AWS CLI c Ubuntu_20**

*https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/create-snapshot.html*

aws ec2 create-snapshot --volume-id vol-06581127d57e1e3aa --description "This is my root volume snapshot"

**Получение списка EBS snapshot при помощи AWS CLI c Ubuntu_20**

https://aws.amazon.com/ru/premiumsupport/knowledge-center/ebs-snapshots-list/

aws ec2 describe-snapshots --owner-ids self

**Копирование EBS snapshot в S3 при помощи AWS CLI c Ubuntu_20**

https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-copy-snapshot.html

https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/copy-snapshot.html


aws ec2 copy-snapshot --source-region eu-central-1 --source-snapshot-id snap-00b728ed9c6af3c4b  --description "This is my copied snapshot."

**Удаление EBS snapshot при помощи AWS CLI c Ubuntu_20**

*https://docs.aws.amazon.com/cli/latest/reference/ec2/delete-snapshot.html*

aws ec2 delete-snapshot --snapshot-id snap-1234567890abcdef0



***Создал скрипт "task-10.sh"  в соответствии с требованиями задания***

##### [rus]

#### Описание скрипта:

  Скрипт требует установленной и настройнной нативной утилиты aws cli. Пользователь должен обладать правами доступа чтение и запись сервиса AWS EC2.

  <ParN> - это параметры, которые скрипт ищет  в описании снимка. Из этих параметров формируются строки отчёта. Параметры могут быть любым текстом или набором цифр, например "SnapshotId", "VolumeId",  "Description" или любые другие. Параметры можно задавать без учёта регистра. Также можно вводить имя параметра частично. Например, если ввести "id" - скрипт выведет в отчёт все параметры, содержащие в своём имени "id" и их значения.
Скрипт также обрабатывает один специальный параметр "Age". В отличае от остальных, которые просто транслируются от AWS, "Age" вычисляется скриптом. "Age" - это возраст найденных снимков на момент вызова скрипта. Для работы скрипту нужно передать хотябы один параметр.

  Поддерживаемые значения:  значения могут быть любым текстом или набором цифр

  Пример: ./task-10.sh id age description

  <--Com> и <ComNPar> - это соответственно команды и параметры этих команд. Все команды являются необязательными. Скрипт поддерживает следующие команды и значения:

  --age-dimension - установка единиц измерения минимального возраста снимков входящих отчёт

  Поддерживаемые значения:  seconds | minutes | hours | days

  Пример: --age-dimension minutes 

  --age-minimum - установка значения минимального возраста снимков входящих отчёт в установленных при помощи --age-dimension единицах измерения.

  Поддерживаемые значения:  целые положительные числа

  Пример: --age-minimum 123456

  --filter - установка имени или значения атрибута (тега), который должен содержать снимок, чтобы попасть в отчёт. Любые снимки, не содержащие переданный параметр в отчёт не попадают.

  Поддерживаемые значения:  значения могут быть любым текстом или набором цифр

  Пример: --filter snap-01920209545fd225e

  --snapshots-action - установка действий над снимками, попавшими в отчёт. Доступны два возможных действия создание копии или удаление.

  Поддерживаемые значения:  copy| delete

  Пример: --snapshots-action copy

  --get-raw-data - активировать вывод сырых данных с описанием всех имеющихся снимков от AWS.

  Пример: --get-raw-data enable

  --help - выводит эту справку.

  Пример:  --help

#### **Формат выводимых скриптом данных:**

  Имя параметра 1: Значение параметра 1 | Имя параметра 2: Значение параметра 2 | Имя параметра N: Значение параметра N



##### [eng]

#### Script description:

  The ./task-10.sh script requires the aws cli native utility installed and configured. The user must have read / write access to the AWS EC2 service.

./task-10.sh script usage:
./task-10.sh <Par1> <Par2> ... <ParN> <--Com1> <Com1Par> <--Com2> <Com2Par> ... <--ComN> <ComNPar>

  <ParN> are the parameters that the script looks for in the snapshot description. Report lines are formed from these parameters. Parameters can be any text or a set of numbers, for example "SnapshotId", "VolumeId", "Description" or any others. Parameters can be set case-insensitively. You can also enter the name of the parameter partially. For example, if you enter "id", the script will display all parameters containing "id" and their values in their name.
  The script also handles one special parameter "Age". Unlike the others, which are simply broadcast from AWS, "Age" is calculated by the script. "Age" is the age of the found snapshots at the time the script was called. For the script to work, you need to pass at least one parameter.
  Supported values: values can be any text or set of numbers
  Example: ./task-10.sh id description

  <--Com> and <ComNPar> are the commands and parameters of these commands, respectively. All commands are optional. The script supports the following commands and values:

  --age-dimension - set the units of measure for the minimum age of images for incoming reports
  Supported values: seconds | minutes | hours | days
  Example: --age-dimension minutes

  --age-minimum - set the value of the minimum age of snapshots included in the report in units of measurement set using --age-dimension.
  Supported values: positive integers
  Example: --age-minimum 123456

  --filter - setting the name or value of the attribute (tag) that the snapshot must contain to get into the report. Any images that do not contain the passed parameter are not included in the report.
  Supported values: values can be any text or set of numbers
  Example: --filter snap-01920209545fd225e

  --snapshots-action - setting actions for snapshots included in the report. Two possible actions are available: create a copy or delete.
  Supported values: copy | delete
  Example: --snapshots-action copy

  --get-raw-data - activate the output of raw data with a description of all available snapshots from AWS.
  Supported values: enable
  Example: --get-raw-data enable

  --help - displays this help.
  Example: --help

#### **The format of the data output by the script:**


Parameter name 1: Parameter value 1 | Parameter name 2: Parameter value 2 | Parameter name N: Parameter value N
