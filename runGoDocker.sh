#!/bin/bash


# do not rebuild docker aicplayer
TAG_IMG_DOCKER="hwg"
TAG_REPO_DOCKER="hwgrepo"
HWG_DOCKER="hwgdocker"

rm -f dockerimages.txt
docker images > dockerimages.txt
cat dockerimages.txt 

TAGGED_IMG_DOCKER=`cat dockerimages.txt | grep $TAG_IMG_DOCKER | awk '{print $2}'`

if [ "$TAGGED_IMG_DOCKER" = "$TAG_IMG_DOCKER" ]
then
	echo "=="
	ID_INST_DOCKER=`docker ps -a | grep $HWG_DOCKER | awk '{print $1}'`

else
	echo "!="
	docker build .
	ID_IMG_DOCKER=`docker images |  awk 'NR==2{print $3}'`
	docker tag  ${ID_IMG_DOCKER} $TAG_REPO_DOCKER:$TAG_IMG_DOCKER
fi

docker run -v="/tmp/.X11-unix:/tmp/.X11-unix:rw" -ti --name $HWG_DOCKER $TAG_REPO_DOCKER:$TAG_IMG_DOCKER bash

## supprimer les images dockers non taggées
#docker images | grep "^<none>" > tmp_rmi.txt ; cat tmp_rmi.txt  ; awk '{print $3}' tmp_rmi.txt  | xargs docker rmi -f ; rm -f tmp_rmi.txt

## supprimer les images dockers taggées 
#docker images | grep "$TAG_IMG_DOCKER" > tmp_rmi.txt ; cat tmp_rmi.txt  ; awk '{print $3}' tmp_rmi.txt  | xargs docker rmi -f ; rm -f tmp_rmi.txt

