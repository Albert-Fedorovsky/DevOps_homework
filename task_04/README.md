# task_04

#### Работы по четвёртому заданию:

**Создание нового telegram бота:**

В telergam открываем (новый) чат с ботом @BotFather

Инициируем диалог:

`/start`

Запрашиваем создание нового бота:

`/newbot`

Вводим желаемое имя (name) нового бота:

`Albert_F_gobot`

Вводим имя пользователя (username) для нового бота

`albert_f_gobot`

Переходим в меню своих ботов:

`/mybots`

Нажимаем на кнопку с username вновь созданного бота

Нажимаем на кнопку с "Edit Bot"

Нажимаем на кнопку "Edit Commands", после чего вводим имя и описание новой команды:

`number_of_users - number of users who used bot`

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

**Установка по на Ubuntu_20:**

sudo apt-get update

sudo apt-get install golang

sudo apt-get install curl

Установка ngrock:

`curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list && sudo apt update && sudo apt install ngrok` 

**Настройка переменных окружения на Ubuntu_20:**

nano ~/.bashrc

*~/.bashrc:*

`export GOPATH=~/go`
`export PATH=$PATH:GOPATH/bin`

source ~/.bashrc

echo $GOPATH

echo $PATH

**Установка библиотек golang:**

go get github.com/Syfaro/telegram-bot-api

go get github.com/lib/pq

**Работа с ботом:**

Проверка работы go сервера бота:

Генерация внешнего URL:

ngrok http 3000

Установка вебхука для захвата поступающих боту сообщений:

curl -F "url=https://8bda-87-117-57-153.ngrok.io"  https://api.telegram.org/bot5035269362:AAEfcoCZvOt8wv6zVLgQst4Fzk2eJU-Syu4/setWebhook



