#!/bin/bash -u

. ./.env
. ./.common.sh

echo "${bold}*************************************"
echo "Stopping And Remove Network..."
echo "*************************************${normal}"

echo "Stop docker containers"
echo "-------------------------------------"

export BOOTNODE=$(cat nodes/validator1/key.pub)

docker-compose -f docker-compose.validator$1.yml down -v

rm -rf ./logs/besu