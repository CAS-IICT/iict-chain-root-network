#!/bin/bash -u

. ./.env
. ./.common.sh

NODE_NAME=$1

if [ -z $NODE_NAME ]; then
  fatalln "no validator name was provided"
fi

if [ $NODE_NAME == 'validator1' -o $NODE_NAME == 'validator2' -o $NODE_NAME == 'validator3' -o $NODE_NAME == 'validator4' ]; then
  fatalln "validator name can not be 'validator1' 'validator2' 'validator3' 'validator4', because they are bootnodes"
fi

if [ -d nodes/$NODE_NAME  ]; then
    fatalln "$NODE_NAME already exist!"
fi

BESU_DIR=$PWD/besu

if [ -d $BESU_DIR/node ]; then
    rm -rf $BESU_DIR/node
fi

docker run -v $BESU_DIR:/besu --rm hyperledger/besu:$BESU_VERSION operator generate-blockchain-config --config-file=/besu/node-config.json --to=/besu/node

ADDRESS=$(ls $BESU_DIR/node/keys)
KEY_PRI=$(cat $BESU_DIR/node/keys/$ADDRESS/key.priv)
KEY_PUB=$(cat $BESU_DIR/node/keys/$ADDRESS/key.pub)
mkdir -p nodes/$NODE_NAME
echo -n ${ADDRESS:2} > nodes/$NODE_NAME/address
echo -n ${KEY_PRI:2} > nodes/$NODE_NAME/key
echo -n ${KEY_PUB:2} > nodes/$NODE_NAME/key.pub

rm -rf $BESU_DIR/node