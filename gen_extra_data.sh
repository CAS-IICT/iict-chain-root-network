#!/bin/bash -u

# 生成gensis.json中extraData

. ./.env
. ./.common.sh

BESU_DIR=$PWD/besu

count=$(ls -l nodes|grep "^d"|wc -l)
echo '['  > $BESU_DIR/nodes.json
index=1
for node in $(ls nodes); do
  if [ $index -lt 5 ]; then
    echo '"'$(cat nodes/$node/address)'"' >> $BESU_DIR/nodes.json
    if [ $index -lt 4 ]; then
      echo ',' >> $BESU_DIR/nodes.json
    fi
  fi
  let index++
done
echo ']'  >> $BESU_DIR/nodes.json


docker run -v $BESU_DIR:/besu --rm hyperledger/besu:$BESU_VERSION rlp encode --from=/besu/nodes.json --to=/besu/extra_data --type=IBFT_EXTRA_DATA

cat $BESU_DIR/extra_data

rm -rf $BESU_DIR/nodes.json
rm -rf $BESU_DIR/extra_data
