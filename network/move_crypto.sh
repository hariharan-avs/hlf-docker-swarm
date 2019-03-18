# sudo mkdir -p /var/mynetwork
# sudo chown -R $(whoami) /var/mynetwork
# sudo chown -R $USER:$USER /var/mynetwork
rm -rf mkdir /var/mynetwork/*

mkdir -p /var/mynetwork/chaincode_simple
mkdir -p /var/mynetwork/chaincode_smallbank
mkdir -p /var/mynetwork/certs
mkdir -p /var/mynetwork/bin
mkdir -p /var/mynetwork/fabric-src

git clone https://github.com/hyperledger/fabric /var/mynetwork/fabric-src/hyperledger/fabric
cd /var/mynetwork/fabric-src/hyperledger/fabric
git checkout release-1.4
cd -
cp -R crypto-config /var/mynetwork/certs/
cp -R config /var/mynetwork/certs/
cp -R ../chaincode_simple/* /var/mynetwork/chaincode_simple/
cp -R ../chaincode_smallbank/* /var/mynetwork/chaincode_smallbank/
cp -R bin/* /var/mynetwork/bin/
