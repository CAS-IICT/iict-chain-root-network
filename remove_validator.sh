#!/bin/bash -u

# 添加新validator的步骤
# 1. 生成validator节点公钥、私钥和地址
# 2. 启动节点，接入网络
# 3. 网络中现有validator节点发起投票，需要不少于二分之一的节点同意加入
# 4. 验证新的validator是否添加成功

. ./.env
. ./.common.sh

NODE_NAME=$1

warnln "Propose adding the new validator"
warnln "--------------------"
ADDRESS=$(cat nodes/$NODE_NAME/address)

function remove_validator(){
    curl -X POST --data '{"jsonrpc":"2.0","method":"ibft_proposeValidatorVote","params":["'$1'", false], "id":1}' $2
}

remove_validator $ADDRESS http://127.0.0.1:8545
remove_validator $ADDRESS http://127.0.0.1:28545
remove_validator $ADDRESS http://127.0.0.1:38545
remove_validator $ADDRESS http://127.0.0.1:48545


# 判断是否添加成功
# curl -X POST --data '{"jsonrpc":"2.0","method":"qbft_getValidatorsByBlockNumber","params":["latest"], "id":1}' http://127.0.0.1:18545