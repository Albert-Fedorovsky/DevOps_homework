# task_06

#### Работы по шестому заданию:

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

sudo apt-get install net-tools

sudo apt-get install docker.io

**Создание рецепта сборки контейнера:**

nano ~/Dockerfile

*~/Dockerfile:*

`FROM alpine`
`MAINTAINER Albert Fedorovsky <alb271@yandex.ru>`

`RUN apk update`

`# Install python, pip and flask`
`ENV PYTHONUNBUFFERED=1`
`RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python`
`RUN python3 -m ensurepip`
`RUN pip3 install --no-cache --upgrade pip setuptools`
`RUN pip3 install flask`

`# Set ports`
`EXPOSE 5000`

`ADD main.py /flask_app/`
`CMD ["python3", "/flask_app/main.py"]`

**Сборка контейнера docker:**

sudo docker build -t flask_app .

sudo docker images

*размер получился 85.7 MB*

**Запуск контейнера docker:**

*Запуск с входом в контейнер (для отладки):*

sudo docker run -it flask_app sh

*Запуск контейнера в фоне (боевой):*

sudo docker run -d -p 8080:5000 flask_app 

*Отладка запущенного в фоне контейнера:*

sudo docker ps

sudo docker exec -i -t <ID> sh

**Остановка контейнера:**

sudo docker ps

sudo docker stop <ID>

**Удаление образа контейнера:**

sudo docker images

sudo docker rmi <ID> -f

