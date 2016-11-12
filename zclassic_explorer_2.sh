#!/bin/bash

# Patryk 'jamzed' Kuzmicz
# 2016/11/12

WHO=$(whoami)

# install npm v4
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
nvm install v4

# install ZeroMQ libraries
sudo apt-get -y install libzmq3-dev

# install bitcore (branched and patched from https://github.com/str4d/zcash)
npm install jamzed/bitcore-node-zcash

# create bitcore node
./node_modules/bitcore-node-zcash/bin/bitcore-node create zclassic-explorer
cd zclassic-explorer

# install patched insight api/ui (branched and patched from https://github.com/str4d/zcash)
../node_modules/bitcore-node-zcash/bin/bitcore-node install jamzed/insight-api-zcash jamzed/insight-ui-zcash

# create bitcore config file for bitcore and zcashd/zclassicd
cat << EOF > bitcore-node.json
{
  "network": "mainnet",
  "port": 3001,
  "services": [
    "bitcoind",
    "insight-api-zcash",
    "insight-ui-zcash",
    "web"
  ],
  "servicesConfig": {
    "bitcoind": {
      "spawn": {
        "datadir": "./data",
        "exec": "/home/$WHO/zcash/src/zcashd"
      }
    }
  }
}

EOF

# create zcash.conf
cat << EOF > data/zcash.conf
addnode=104.216.118.162:8313
server=1
whitelist=127.0.0.1
txindex=1
addressindex=1
timestampindex=1
spentindex=1
zmqpubrawtx=tcp://127.0.0.1:8332
zmqpubhashblock=tcp://127.0.0.1:8332
rpcallowip=127.0.0.1
rpcuser=bitcoin
rpcpassword=local321
uacomment=bitcore
showmetrics=0

EOF

echo "Start the block explorer, open in your browser http://server_ip:3001"
echo "nvm use v4; ./node_modules/bitcore-node-zcash/bin/bitcore-node start"
