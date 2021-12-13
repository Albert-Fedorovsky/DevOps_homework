# task_05

#### Работы по пятому заданию:

**Установка ПО на Windows 10:**

notepad++

Typora

BvSshClient

Oracle virtual box

**Установка виртуальных машин на virtual box:**

1шт.: "Debian_10_gitlab"

обе на базе образа "debian-live-10.0.0-amd64-gnome.iso"

сетевой интерфейс сконфигурирован как bridge

при установке создан пользователь user

после установки пользователь user добавлен в группу root (usermod -aG sudo user)

Debian_10_gitlab установлен статический IP 192.168.1.103

**Установка ПО на Debian_10_gitlab:**

sudo apt-get uptade

sudo apt-get install ssh

sudo nano /etc/ssh/sshd_config

*/etc/ssh/sshd_config*

`PermitRootLogin yes`

sudo systemctl restart ssh

sudo apt install docker.io

nano ~/.bashrc

*~/.bashrc:*

`export GITLAB_HOME=/srv/gitlab`

source ~/.bashrc

echo $GITLAB_HOME

sudo docker pull gitlab/gitlab-ce:latest

mkdir ~/docker/

mkdir ~/docker/gitlab

cd ~/docker/gitlab

nano volumes_to_store_persistent_data

*volumes_to_store_persistent_data:*

`Local location          Container location      Usage`
`$GITLAB_HOME/data       /var/opt/gitlab         For storing application data.`
`$GITLAB_HOME/logs       /var/log/gitlab         For storing logs.`
`$GITLAB_HOME/config     /etc/gitlab             For storing the GitLab configuration files.`

sudo ss -tulpn

nano install.sh

*install.sh*

`#!/bin/bash`
`sudo docker run --detach \`
  `--hostname gitlab.192.168.1.103 \`
  `--publish 443:443 --publish 80:80 --publish 23:22 \`
  `--name gitlab \`
  `--restart always \`
  `--volume $GITLAB_HOME/config:/etc/gitlab \`
  `--volume $GITLAB_HOME/logs:/var/log/gitlab \`
  `--volume $GITLAB_HOME/data:/var/opt/gitlab \`
  `gitlab/gitlab-ce:latest`

chmod +x install.sh

sudo ./install.sh

sudo docker ps

sudo docker logs -f gitlab

**Настройки gitlab:**

sudo docker exec -it gitlab grep 'Password:' /etc/gitlab/initial_root_password

В результате выполнения последней команды будей выдан пароль для пользователя root. Далее можно авторизоваться через веб интерфейс gitlab: http://192.168.1.103/users/sign_in

Основной конфигурационный файл:

sudo nano /config/gitlab.rb

