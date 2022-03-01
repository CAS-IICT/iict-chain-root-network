curl -X POST --data '{"jsonrpc":"2.0","method":"admin_peers","params":[],"id":1}' http://47.242.195.124:8545

curl -X POST --data '{"jsonrpc":"2.0","method":"admin_nodeInfo","params":[],"id":1}' http://47.242.195.124:8545

curl -X POST --data '{"jsonrpc":"2.0","method":"ibft_getValidatorsByBlockNumber","params":["latest"], "id":1}' http://localhost:31545

curl -X POST --data '{"jsonrpc":"2.0","method":"txpool_besuPendingTransactions","params":[2],"id":1}' http://cas-ll.com:8545


echo "Deploy permission contracts"
echo "-------------------------------------"

if [ ! -d permissioning-smart-contracts ]; then
    git clone https://github.com/ConsenSys/permissioning-smart-contracts.git
fi

cat <<EOF > permissioning-smart-contracts/.env
NODE_INGRESS_CONTRACT_ADDRESS=0x0000000000000000000000000000000000009999
ACCOUNT_INGRESS_CONTRACT_ADDRESS=0x0000000000000000000000000000000000008888
BESU_NODE_PERM_ACCOUNT=$(cat nodes/bootnode/address)
BESU_NODE_PERM_KEY=$(cat nodes/bootnode/key)
BESU_NODE_PERM_ENDPOINT=http://127.0.0.1:8545
CHAIN_ID=1337
EOF

exit 1
pushd permissioning-smart-contracts
yarn install
yarn run build
yarn truffle migrate --reset --network besu
yarn start
# 如果metamask中找不到合约，需要重设一下账号，清除交易历史记录
popd

--permissions-nodes-contract-enabled \
        --permissions-nodes-contract-version=2 \
        --permissions-accounts-contract-enabled \
        --permissions-nodes-contract-address=0x0000000000000000000000000000000000009999 \
        --permissions-accounts-contract-address=0x0000000000000000000000000000000000008888 \