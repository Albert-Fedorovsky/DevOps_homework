#!/bin/bash
echo "-------------------- Launch container started ---------------------------"

container_to_stop=$(docker ps -aq --filter ancestor=alb271/go_app)
docker stop "$container_to_stop"
containers_to_remove=$(docker container ls -aq --filter ancestor=alb271/go_app)
docker rm "$containers_to_remove"
images_to_remove=$(docker images -q alb271/go_app)
docker rmi "$images_to_remove"
docker pull alb271/go_app
docker run -d -p 8080:8181 alb271/go_app

echo "------------------- Launch container finished ---------------------------"
