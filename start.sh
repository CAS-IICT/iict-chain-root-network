#!/bin/bash -u

. ./.env
. ./.common.sh

warnln "${bold}*************************************"
warnln "Starting Network..."
warnln "*************************************${normal}"

mkdir -p logs/besu
chmod -R 0777 logs

if [ ! -f config/genesis.json ]; then
    echo "Generate network"
    echo "-------------------------------------"
    ./create_network.sh
fi


docker-compose -f docker-compose.validator$1.yml up -d