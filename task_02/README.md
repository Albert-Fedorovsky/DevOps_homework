# task_02

#### Работы по второму заданию:

**Установка ПО на Windows 10:**

notepad++

Typora

BvSshClient

Oracle virtual box

**Установка виртуальных машин на virtual box:**

3шт.: "Debian_10_ansible", "Debian_10_web_server1", "Debian_10_web_server2"

обе на базе образа "debian-live-10.0.0-amd64-gnome.iso"

сетевой интерфейс в обоих случаях сконфигурирован как bridge

при установке создан пользователь user

после установки пользователь user добавлен в группу root (usermod -aG sudo user)

Debian_10_ansible установлен статический IP 192.168.1.100

Debian_10_web_server1 установлен статический IP 192.168.1.101

Debian_10_web_server2 установлен статический IP 192.168.1.102

**Установка ПО на Debian_10_web_server1 и Debian_10_web_server2:**

sudo apt-get update

sudo apt-get install ssh

sudo nano /etc/ssh/sshd_config

*/etc/ssh/sshd_config*

`PermitRootLogin yes`

sudo systemctl restart ssh

**Создание python3 + flask приложения:**

mkdir ~/flask_app/

cd ~/flask_app/

nano ~/flask_app/main.py

*/flask_app/main.py:*

`from flask import Flask`

`app = Flask(__name__)`

`@app.route('/')`
`def index():`
	`mytext = "<h1>task_02:</h1> <h2>Hello DevOps!</h2> <p>This is a simple phyton3 + flask application made by Albert Fedorovsky! :-)</p>"`
	`return mytext`

`if __name__ == "__main__":`
    `app.run(host= '0.0.0.0')`

**Создание скрипта для регистрации python3 + flask приложения в системе как сервиса:**

`sudo nano /lib/systemd/system/flask_app.service`

 `*/lib/systemd/system/flask_app.service:*`

`[Unit]`
  `Description=My python3 + flask_app`

`[Service]`
  `ExecStart=/usr/bin/python3 -u /home/user/flask_app/main.py`
  `Type=idle`
  `KillMode=process`

  `SyslogIdentifier=smart-test`
  `SyslogFacility=daemon`

  `Restart=on-failure`

`[Install]`
  `WantedBy=multiuser.target`

sudo systemctl start flask_app.service

sudo systemctl status flask_app.service

sudo systemctl stop flask_app.service

sudo systemctl enable flask_app.service

sudo systemctl list-unit-files | grep enabled

**Установка ПО на Debian_10_ansible:**

sudo apt-add-repository ppa:ansible/ansible

sudo apt-get update

sudo apt-get install ssh

sudo nano /etc/ssh/sshd_config

*/etc/ssh/sshd_config*
`PermitRootLogin yes`

sudo systemctl restart ssh

ssh-keygen

ssh-copy-id root@192.168.1.101

ssh-copy-id root@192.168.1.102

sudo apt-get install git

sudo apt install ansible

sudo chown -R user /etc/ansible/

**Базовая конфигурация Ansible:**

nano /etc/ansible/ansible.cfg

*/etc/ansible/ansible.cfg:*

`inventory       = /etc/ansible/hosts`
`host_key_checking = False`
`remote_tmp      = /tmp/${USER}/ansible`

nano /etc/ansible/hosts

*/etc/ansible/hosts:*
`[servers]`
`web_server1 ansible_host=192.168.1.101`
`web_server2 ansible_host=192.168.1.102`

`[servers:vars]`
`ansible_python_interpreter=/usr/bin/python3`
`ansible_user=root`

Проверка доступа ansible к Debian_10_web_server1 и Debian_10_web_server2 :

ansible all -m ping

**Создание плейбука для Ansible, доставляющего python3 + flask приложение на сервера:**

mkdir /etc/ansible/playbooks

Плейбук yml:

nano /etc/ansible/playbooks/flask_app_delivery.yml

*/etc/ansible/playbooks/flask_app_delivery.yml:*

---
- `name: flask_app delivery`
  `hosts: servers`
  `become: yes`

  `tasks:`
  
  - `name: Ensure subversion is present`
    `apt:`
     `name: subversion`
     `state: present`
  
  - `name: Ensure python-pip is present`
    `apt:`
     `name: "{{ packages }}"`
     `state: present`
    `vars:`
      `packages:`
    
     `- python-pip`
  
     `- python3-pip`
    
  - `name: Copy flask_app.service file`
    `copy:`
     `src: flask_app.service`
     `dest: /lib/systemd/system/flask_app.service`
     `owner: root`
     `group: root`
     `mode: u=rw,g=r,o=r`
  
  - `name: Ensure flask_app.service is stopped`
    `service:`
     `name: flask_app`
     `state: stopped`
  
  - `name: Install flask`
    `script: /etc/ansible/playbooks/flask_install.sh`
  
  - `name: Download new version of flask_app from github`
    `script: /etc/ansible/playbooks/flask_app_delivery.sh`
  
  - `name: Check flask_app.service is enabled`
    `service:`
     `name: flask_app`
     `enabled: yes`
  
  - `name: Ensure flask_app.service is started`
    `service:`
     `name: flask_app`
     `state: started`

**Создание скрипта устанавливающего библиотеку flask на Debian_10_web_server1 и  Debian_10_web_server2:**

nano /etc/ansible/playbooks/flask_app_delivery.sh

*/etc/ansible/playbooks/flask_install.sh:*

`#!/bin/bash`
`pip3 install flask`

**Создание скрипта получающего новую версию flask_app с моего репозитория github на Debian_10_web_server1 и Debian_10_web_server2:**

nano /etc/ansible/playbooks/flask_app_delivery.sh

*/etc/ansible/playbooks/flask_app_delivery.sh:*

`#!/bin/bash`
`cd /home/user/`
`svn checkout https://github.com/Albert-Fedorovsky/DevOps_homework/trunk/task_02/flask_app/`

**Запуск плейбука Debian_10_ansible:**

ansible-playbook /etc/ansible/playbooks/flask_app_delivery.yml

