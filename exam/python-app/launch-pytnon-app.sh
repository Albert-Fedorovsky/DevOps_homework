#!/bin/bash
echo "-------------------- Launch container started ---------------------------"

container_to_stop=$(docker ps -aq --filter ancestor=alb271/python_app)
docker stop "$container_to_stop"
containers_to_remove=$(docker container ls -aq --filter ancestor=alb271/python_app)
docker rm "$containers_to_remove"
images_to_remove=$(docker images -q alb271/python_app)
docker rmi "$images_to_remove"
docker pull alb271/python_app
docker run -d -p 80:5000 alb271/python_app

echo "------------------- Launch container finished ---------------------------"
