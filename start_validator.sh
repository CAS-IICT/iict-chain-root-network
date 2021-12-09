#!/bin/bash -u

# 添加新validator的步骤
# 1. 生成validator节点公钥、私钥和地址
# 2. 启动节点，接入网络
# 3. 网络中现有validator节点发起投票，需要不少于二分之一的节点同意加入
# 4. 验证新的validator是否添加成功

. ./.env
. ./.common.sh

NODE_NAME=""
RPC_HTTP_PORT=""

function printHelp(){
  successln "./start_validator.sh --name validator5 --rpc-http-port=8545"
  exit 1
}

while [[ $# -ge 1 ]] ; do
  key="$1"
  case $key in
  --name )
    export NODE_NAME="$2"
    shift
    ;;
  --rpc-http-port )
    export RPC_HTTP_PORT="$2"
    shift
    ;;
  -h )
    printHelp
    shift
    ;;
  esac
  shift
done

if [ -z $NODE_NAME ]; then
  fatalln "no validator name was provided"
fi

if [ $NODE_NAME == 'validator1' -o $NODE_NAME == 'validator2' -o $NODE_NAME == 'validator3' -o $NODE_NAME == 'validator4' ]; then
  fatalln "validator name can not be 'validator1' 'validator2' 'validator3' 'validator4', because they are bootnodes"
fi

if [ -z $RPC_HTTP_PORT ]; then
  fatalln "no rpc port was provided"
fi

if [ ! -d nodes/$NODE_NAME  ]; then
    fatalln "$NODE_NAME don't exist!"
fi

warnln "Start validator container"
warnln "--------------------"
mkdir -p logs/besu
chmod -R 0777 logs

docker-compose -f docker-compose.validator.yml up -d

exit 1

warnln "Propose adding the new validator"
warnln "--------------------"
ADDRESS=$(cat nodes/$NODE_NAME/address)

function add_validator(){
    curl -X POST --data '{"jsonrpc":"2.0","method":"qbft_proposeValidatorVote","params":["'$1'", true], "id":1}' $2
}

function remove_validator(){
    curl -X POST --data '{"jsonrpc":"2.0","method":"qbft_proposeValidatorVote","params":["'$1'", false], "id":1}' $2
}


remove_validator $ADDRESS http://127.0.0.1:18545
remove_validator $ADDRESS http://127.0.0.1:28545
remove_validator $ADDRESS http://127.0.0.1:38545
remove_validator $ADDRESS http://127.0.0.1:48545


# 判断是否添加成功
# curl -X POST --data '{"jsonrpc":"2.0","method":"qbft_getValidatorsByBlockNumber","params":["latest"], "id":1}' http://127.0.0.1:18545