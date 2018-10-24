# balias_def_docker.fish
# author: Seong Yong-ju <sei40kr@gmail.com>

## almost from Prezto
balias dk docker
balias dka 'docker attach'
balias dkb 'docker build'
balias dkd 'docker diff'
balias dkdf 'docker system df'
balias dke 'docker exec'
balias dkE 'docker exec -it'
balias dkh 'docker history'
balias dki 'docker images'
balias dkin 'docker inspect'
balias dkim 'docker import'
balias dkk 'docker kill'
balias dkl 'docker logs'
balias dkli 'docker login'
balias dklo 'docker logout'
balias dkls 'docker ps'
balias dkp 'docker pause'
balias dkP 'docker unpause'
balias dkpl 'docker pull'
balias dkph 'docker push'
balias dkps 'docker ps'
balias dkpsa 'docker ps -a'
balias dkr 'docker run'
balias dkR 'docker run -it --rm'
balias dkRe 'docker run -it --rm --entrypoint /bin/bash'
balias dkRM 'docker system prune -af'
balias dkrm 'docker rm'
balias dkrmi 'docker rmi'
balias dkrn 'docker rename'
balias dks 'docker start'
balias dkS 'docker restart'
balias dkss 'docker stats'
balias dksv 'docker save'
balias dkt 'docker tag'
balias dktop 'docker top'
balias dkup 'docker update'
balias dkV 'docker volume'
balias dkv 'docker version'
balias dkw 'docker wait'
balias dkx 'docker stop'
# Container (C)
balias dkC 'docker container'
balias dkCa 'docker container attach'
balias dkCcp 'docker container cp'
balias dkCd 'docker container diff'
balias dkCe 'docker container exec'
balias dkCin 'docker container inspect'
balias dkCk 'docker container kill'
balias dkCl 'docker container logs'
balias dkCls 'docker container ls'
balias dkCp 'docker container pause'
balias dkCpr 'docker container prune'
balias dkCrn 'docker container rename'
balias dkCS 'docker container restart'
balias dkCrm 'docker container rm'
balias dkCr 'docker container run'
balias dkCR 'docker container run -it --rm'
balias dkCRe 'docker container run -it --rm --entrypoint /bin/bash'
balias dkCs 'docker container start'
balias dkCss 'docker container stats'
balias dkCx 'docker container stop'
balias dkCtop 'docker container top'
balias dkCP 'docker container unpause'
balias dkCup 'docker container update'
balias dkCw 'docker container wait'
# Image (I)
balias dkI 'docker image'
balias dkIb 'docker image build'
balias dkIh 'docker image history'
balias dkIim 'docker image import'
balias dkIin 'docker image inspect'
balias dkIls 'docker image ls'
balias dkIpr 'docker image prune'
balias dkIpl 'docker image pull'
balias dkIph 'docker image push'
balias dkIrm 'docker image rm'
balias dkIsv 'docker image save'
balias dkIt 'docker image tag'
# Volume (V)
balias dkV 'docker volume'
balias dkVin 'docker volume inspect'
balias dkVls 'docker volume ls'
balias dkVpr 'docker volume prune'
balias dkVrm 'docker volume rm'
# Network (N)
balias dkN 'docker network'
balias dkNs 'docker network connect'
balias dkNx 'docker network disconnect'
balias dkNin 'docker network inspect'
balias dkNls 'docker network ls'
balias dkNpr 'docker network prune'
balias dkNrm 'docker network rm'
# System (Y)
balias dkY 'docker system'
balias dkYdf 'docker system df'
balias dkYpr 'docker system prune'
# Stack (K)
balias dkK 'docker stack'
balias dkKls 'docker stack ls'
balias dkKps 'docker stack ps'
balias dkKrm 'docker stack rm'
# Swarm (W)
balias dkW 'docker swarm'

balias alpine-sh 'docker run -it --rm alpine:latest /bin/sh'
balias centos-bash 'docker run -it --rm centos:latest /bin/bash'
balias arch-bash 'docker run -it --rm base/archlinux:latest /bin/bash'
balias ubuntu-bash 'docker run -it --rm ubuntu:latest /bin/bash'