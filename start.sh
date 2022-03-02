#!/bin/bash -u

. ./.env
. ./.common.sh

warnln "${bold}*************************************"
warnln "Starting Network..."
warnln "*************************************${normal}"

if [ ! -f config/genesis.json ]; then
    echo "Generate network"
    echo "-------------------------------------"
    ./create_network.sh
fi

if [ ! -d logs ]; then
    mkdir -p logs/besu
    chmod -R 0777 logs
fi

if [ ! -d datas/$1 ]; then
    mkdir -p datas/$1
    chmod -R 0777 datas/$1
fi

docker-compose -f dockers/$1.yml up -d