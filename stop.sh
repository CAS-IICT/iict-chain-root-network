#!/bin/bash -u

. ./.env
. ./.common.sh

echo "${bold}*************************************"
echo "Stopping And Remove Network..."
echo "*************************************${normal}"

echo "Stop docker containers"
echo "-------------------------------------"

export BOOTNODE=$(cat nodes/validator1/key.pub)

docker-compose -f dockers/$1.yml down -v