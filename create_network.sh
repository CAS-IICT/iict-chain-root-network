#!/bin/bash -u

# 创建初始网络包括4个validator节点

. ./.env
. ./.common.sh

BESU_DIR=$PWD/besu

if [ -f config/genesis.json  ]; then
    fatalln 'network already exist!'
fi

if [ -d $BESU_DIR/network ]; then
    rm -rf $BESU_DIR/network
fi

docker run -v $BESU_DIR:/besu --rm hyperledger/besu:$BESU_VERSION operator generate-blockchain-config --config-file=/besu/network-config.json --to=/besu/network

cp $BESU_DIR/network/genesis.json config/genesis.json

index=1
for KEY in $(ls $BESU_DIR/network/keys); do
  ADDRESS=$KEY
  KEY_PRI=$(cat $BESU_DIR/network/keys/$ADDRESS/key.priv)
  KEY_PUB=$(cat $BESU_DIR/network/keys/$ADDRESS/key.pub)
  NODE_NAME='validator'$index
  mkdir -p nodes/$NODE_NAME
  echo -n ${ADDRESS:2} > nodes/$NODE_NAME/address
  echo -n ${KEY_PRI:2} > nodes/$NODE_NAME/key
  echo -n ${KEY_PUB:2} > nodes/$NODE_NAME/key.pub
  let index++
done

rm -rf $BESU_DIR/network
