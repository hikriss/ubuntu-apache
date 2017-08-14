# Ubuntu with Apache in docker

## Test it, the output is hostname/Container ID
Verify the image.
```sh
docker run -d -p 5000:80 hikriss/mysite
```
Then, use Chrome/IE/Firefox to browse to 'http://localhost:5000'

## Share local folder
To share local folder with friends.
```sh
docker run -d -p <port_exposed>:80 -v <local folder>:/var/www hikriss/mysite
```
Note: Docker for Windows uses absolute local path.

## Check process running
```sh
docker ps
CONTAINER ID        IMAGE                        COMMAND                CREATED             STATUS              PORTS                  NAMES
25e2ed982bcb        hikriss/mysite:release-1.0   "/usr/local/bin/run"   9 minutes ago       Up 9 minutes        0.0.0.0:5000->80/tcp   wonderful_swanson
```

## Stop process
```sh
docker stop <container id from docker ps>
```
## Check docker image in local machine
```sh 
docker image ls
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
hikriss/mysite      release-1.0         d2b9efa89c53        15 minutes ago      258MB
hikriss/mysite      latest              a1ea6d09721c        About an hour ago   258MB
d4w/nsenter         latest              9e4f13a0901e        10 months ago       83.8kB
```

## remove unused/stopped container
```sh
docker rm <container id from docker ps>
```

# Docker Compose
## Docker Compose to start services from docker-compose.yml
```sh
docker-compose up
```

## compose file (without Swarm)
this is a docker-compose.yml
```sh
version: "3"
services:
  web:
    # replace username/repo:tag with your name and image details
    image: hikriss/mysite:latest
    ports:
     - "5000:80"
    volumes:
     - .:/var/www
```

## to stop services 
```sh 
docker-compose down
Stopping trainning_web_1 ... done
Removing trainning_web_1 ... done
Removing network trainning_default
```

# Docker swarm
## create swarm cluster
the command below will create the SWarm manager node and also print how to join to this cluster on stdout.
```sh
docker swarm init
Swarm initialized: current node (biquah13xnljg90b738mxv15q) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-0msistoyg1zsskn3divyrifh3i3ay8cgkw21msgknkpa6gvfse-e0bxcqztb2tzmj53itq97jlp2 192.168.65.2:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```
## join worker node to Swarm manager
use output from create Swarm

## check how many node to join in this cluster
```sh
docker node ls
ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS
biquah13xnljg90b738mxv15q *   moby                Ready               Active              Leader
```
##  deploy stack in Swarm cluster
This cluster has only 1 machine for simplicity.
the docker-compose-swarm has 2 web servers.
```sh
docker stack deploy -c docker-compose-swarm.yml mycluster
Creating network mycluster_webnet
Creating service mycluster_visualizer
Creating service mycluster_web
```
## Check deployed stack in action!
using chrome to browse to 'http://localhost:5000' to see the output of apache server
```sh
hikriss@Kriss-I7:~$ curl localhost:5000
6e5b6145244a
hikriss@Kriss-I7:~$ curl localhost:5000
27378d55c164
hikriss@Kriss-I7:~$ curl localhost:5000
6e5b6145244a
hikriss@Kriss-I7:~$ curl localhost:5000
27378d55c164
```
using chrome to browse to 'http://localhost:8080' to see the output of visualizer

## Update stack 
use the same command with deploy above. Swarm will be check and update only neccesary change

## Check status of cluster
```sh
docker stack ps mycluster
ID                  NAME                     IMAGE                             NODE                DESIRED STATE       CURRENT STATE           ERROR               PORTS
jzjrezyfxlcc        mycluster_web.1          hikriss/mysite:latest             moby                Running             Running 7 minutes ago
r9ci79k6bewg        mycluster_visualizer.1   dockersamples/visualizer:stable   moby                Running             Running 6 minutes ago
m2kzrcdsenpf        mycluster_web.2          hikriss/mysite:latest             moby                Running             Running 7 minutes ago
```

## Remove stack
```sh
docker stack rm mycluster
Removing service mycluster_web
Removing service mycluster_visualizer
Removing network mycluster_webnet
```

## Remove Swarm if you need
Worker node 
```sh
docker swarm leave
```
Manager node
```sh
docker swarm leave --force
```



