#!/bin/bash -u

. ./.env
. ./.common.sh

echo "${bold}*************************************"
echo "Stopping Validator..."
echo "*************************************${normal}"


docker-compose -f docker-compose.validator.yml down -v