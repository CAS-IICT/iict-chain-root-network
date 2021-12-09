#!/bin/sh

me=`basename "$0"`

if [ "$me" = ".common.sh" ];then
  echo >&2 "This script is not expected to be run separately."
  exit 1
fi

bold=$(tput bold)
normal=$(tput sgr0)

hash docker 2>/dev/null || {
  echo >&2 "This script requires Docker but it's not installed."
  exit 1
}

hash docker-compose 2>/dev/null || {
  echo >&2 "This script requires Docker compose but it's not installed."
  exit 1
}

docker info &>/dev/null
if [ "$?" -eq "1" ];then
  echo >&2 "This script requires Docker daemon to run. Start Docker and try again."
  exit 1
fi

current_dir=${PWD##*/}


C_RESET='\033[0m'
C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_BLUE='\033[0;34m'
C_YELLOW='\033[1;33m'

# println echos string
function println() {
  echo -e "$1"
}

# errorln echos i red color
function errorln() {
  println "${C_RED}${1}${C_RESET}"
}

# successln echos in green color
function successln() {
  println "${C_GREEN}${1}${C_RESET}"
}

# infoln echos in blue color
function infoln() {
  println "${C_BLUE}${1}${C_RESET}"
}

# warnln echos in yellow color
function warnln() {
  println "${C_YELLOW}${1}${C_RESET}"
}

# fatalln echos in red color and exits with fail status
function fatalln() {
  errorln "$1"
  exit 1
}

export -f errorln
export -f successln
export -f infoln
export -f warnln