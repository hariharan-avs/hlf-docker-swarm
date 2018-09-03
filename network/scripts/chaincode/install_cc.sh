#!/bin/bash
GLOBAL_ENV_LOCATION=$PWD/scripts/.env
source $GLOBAL_ENV_LOCATION

set -ev

# ============================
# INSTALLING CHAINCODE simple IN ORG1-peer0
# ============================
docker exec "$CLI_NAME" peer chaincode install -n "$CC_NAME1" -p "$CC_SRC1" -v v0

# ============================
# INSTALLING CHAINCODE simple IN ORG1-peer1
# ============================
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/server.crt" -e "CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/server.key" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" -e "CORE_PEER_ADDRESS=peer1.org1.example.com:7051" "$CLI_NAME" peer chaincode install -n "$CC_NAME1" -p "$CC_SRC1" -v v0

# ============================
# INSTALLING CHAINCODE simple IN ORG2-peer0
# ============================
docker exec -e "CORE_PEER_LOCALMSPID=Org2MSP" -e "CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.crt" -e "CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.key" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" -e "CORE_PEER_ADDRESS=peer0.org2.example.com:7051" "$CLI_NAME" peer chaincode install -n "$CC_NAME1" -p "$CC_SRC1" -v v0

# ============================
# INSTALLING CHAINCODE simple IN ORG2-peer1
# ============================
docker exec -e "CORE_PEER_LOCALMSPID=Org2MSP" -e "CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/server.crt" -e "CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/server.key" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" -e "CORE_PEER_ADDRESS=peer1.org2.example.com:7051" "$CLI_NAME" peer chaincode install -n "$CC_NAME1" -p "$CC_SRC1" -v v0

# ===========================
# INSTANTIATING THE CHAINCODE simple ORG1-peer0
# ===========================
docker exec "$CLI_NAME" peer chaincode instantiate -o "$ORDERER_NAME":7050 -C "$CHANNEL_NAME" -n "$CC_NAME1" "$CC_SRC1" -v v0  -c '{"Args":[]}' -P "OR('Org1MSP.member', 'Org2MSP.member' )" --tls --cafile $ORDERER_CA

# ===========================
# INSTANTIATING THE CHAINCODE simple ORG1-peer1
# ===========================
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/server.crt" -e "CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/server.key" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" -e "CORE_PEER_ADDRESS=peer1.org1.example.com:7051" -e "CORE_PEER_ID=peer1.org1.example.com" -e "CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer1.org1.example.com:7051" -e "CORE_PEER_CHAINCODEADDRESS=peer1.org1.example.com:7052" -e "CORE_PEER_CHAINCODELISTENADDRESS=peer1.org1.example.com:7052" "$CLI_NAME" peer chaincode instantiate -o "$ORDERER_NAME":7050 -C "$CHANNEL_NAME" -n "$CC_NAME1" "$CC_SRC1" -v v0  -c '{"Args":[]}' -P "OR('Org1MSP.member', 'Org2MSP.member' )" --tls --cafile $ORDERER_CA

sleep 5
# ===========================
# INSTANTIATING THE CHAINCODE simple ORG2-peer0
# ===========================
#docker exec -e "CORE_PEER_LOCALMSPID=Org2MSP" -e "CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.crt" -e "CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.key" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" -e "CORE_PEER_ADDRESS=peer0.org2.example.com:7051"  -e "CORE_PEER_ID=peer0.org2.example.com" -e "CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer0.org2.example.com:7051" -e "CORE_PEER_CHAINCODEADDRESS=peer0.org2.example.com:7052" -e "CORE_PEER_CHAINCODELISTENADDRESS=peer0.org2.example.com:7052" "$CLI_NAME" peer chaincode instantiate -o "$ORDERER_NAME":7050 -C "$CHANNEL_NAME" -n "$CC_NAME1" "$CC_SRC1" -v v0  -c '{"Args":[]}' -P "OR('Org1MSP.member', 'Org2MSP.member' )" --tls --cafile $ORDERER_CA

# ===========================
# INSTANTIATING THE CHAINCODE simple ORG2-peer1
# ===========================
#docker exec -e "CORE_PEER_LOCALMSPID=Org2MSP" -e "CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/server.crt" -e "CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/server.key" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" -e "CORE_PEER_ADDRESS=peer1.org2.example.com:7051"  -e "CORE_PEER_ID=peer1.org2.example.com" -e "CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer1.org2.example.com:7051" -e "CORE_PEER_CHAINCODEADDRESS=peer2.org1.example.com:7052" -e "CORE_PEER_CHAINCODELISTENADDRESS=peer1.org2.example.com:7052" "$CLI_NAME" peer chaincode instantiate -o "$ORDERER_NAME":7050 -C "$CHANNEL_NAME" -n "$CC_NAME1" "$CC_SRC1" -v v0  -c '{"Args":[]}' -P "OR('Org1MSP.member', 'Org2MSP.member' )" --tls --cafile $ORDERER_CA

sleep 20

# ============================
# INSTALLING CHAINCODE smallbank IN ORG1-peer0
# ============================
docker exec "$CLI_NAME" peer chaincode install -n "$CC_NAME2" -p "$CC_SRC2" -v v0


# ============================
# INSTALLING CHAINCODE smallbank IN ORG1-peer1
# ============================
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/server.crt" -e "CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/server.key" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" -e "CORE_PEER_ADDRESS=peer1.org1.example.com:7051" "$CLI_NAME" peer chaincode install -n "$CC_NAME2" -p "$CC_SRC2" -v v0

# ============================
# INSTALLING CHAINCODE smallbank IN ORG2-peer0
# ============================
docker exec -e "CORE_PEER_LOCALMSPID=Org2MSP" -e "CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.crt" -e "CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.key" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" -e "CORE_PEER_ADDRESS=peer0.org2.example.com:7051" "$CLI_NAME" peer chaincode install -n "$CC_NAME2" -p "$CC_SRC2" -v v0

# ============================
# INSTALLING CHAINCODE smallbank IN ORG2-peer1
# ============================
docker exec -e "CORE_PEER_LOCALMSPID=Org2MSP" -e "CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/server.crt" -e "CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/server.key" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" -e "CORE_PEER_ADDRESS=peer1.org2.example.com:7051" "$CLI_NAME" peer chaincode install -n "$CC_NAME2" -p "$CC_SRC2" -v v0

# ===========================
# INSTANTIATING THE CHAINCODE smallbank ORG1-peer0
# ===========================
docker exec "$CLI_NAME" peer chaincode instantiate -o "$ORDERER_NAME":7050 -C "$CHANNEL_NAME" -n "$CC_NAME2" "$CC_SRC2" -v v0  -c '{"Args":[]}' -P "OR('Org1MSP.member', 'Org2MSP.member' )" --tls --cafile $ORDERER_CA

# ===========================
# INSTANTIATING THE CHAINCODE smallbank ORG1-peer1
# ===========================
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/server.crt" -e "CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/server.key" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" -e "CORE_PEER_ADDRESS=peer1.org1.example.com:7051" -e "CORE_PEER_ID=peer1.org1.example.com" -e "CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer1.org1.example.com:7051" -e "CORE_PEER_CHAINCODEADDRESS=peer1.org1.example.com:7052" -e "CORE_PEER_CHAINCODELISTENADDRESS=peer1.org1.example.com:7052" "$CLI_NAME" peer chaincode instantiate -o "$ORDERER_NAME":7050 -C "$CHANNEL_NAME" -n "$CC_NAME2" "$CC_SRC2" -v v0  -c '{"Args":[]}' -P "OR('Org1MSP.member', 'Org2MSP.member' )" --tls --cafile $ORDERER_CA

# ===========================
# INSTANTIATING THE CHAINCODE smallbank ORG2-peer0
# ===========================
docker exec -e "CORE_PEER_LOCALMSPID=Org2MSP" -e "CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.crt" -e "CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.key" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" -e "CORE_PEER_ADDRESS=peer0.org2.example.com:7051"  -e "CORE_PEER_ID=peer0.org2.example.com" -e "CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer0.org2.example.com:7051" -e "CORE_PEER_CHAINCODEADDRESS=peer0.org2.example.com:7052" -e "CORE_PEER_CHAINCODELISTENADDRESS=peer0.org2.example.com:7052" "$CLI_NAME" peer chaincode instantiate -o "$ORDERER_NAME":7050 -C "$CHANNEL_NAME" -n "$CC_NAME2" "$CC_SRC2" -v v0  -c '{"Args":[]}' -P "OR('Org1MSP.member', 'Org2MSP.member' )" --tls --cafile $ORDERER_CA

# ===========================
# INSTANTIATING THE CHAINCODE smallbank ORG2-peer1
# ===========================
docker exec -e "CORE_PEER_LOCALMSPID=Org2MSP" -e "CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/server.crt" -e "CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/server.key" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/ca.crt" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" -e "CORE_PEER_ADDRESS=peer1.org2.example.com:7051"  -e "CORE_PEER_ID=peer1.org2.example.com" -e "CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer1.org2.example.com:7051" -e "CORE_PEER_CHAINCODEADDRESS=peer2.org1.example.com:7052" -e "CORE_PEER_CHAINCODELISTENADDRESS=peer1.org2.example.com:7052" "$CLI_NAME" peer chaincode instantiate -o "$ORDERER_NAME":7050 -C "$CHANNEL_NAME" -n "$CC_NAME2" "$CC_SRC2" -v v0  -c '{"Args":[]}' -P "OR('Org1MSP.member', 'Org2MSP.member' )" --tls --cafile $ORDERER_CA


# ================================
# LISTING THE CHAINCODES INSTALLED
# ================================
docker exec "$CLI_NAME" peer chaincode list --instantiated -C "$CHANNEL_NAME" --tls --cafile $ORDERER_CA

sleep 10

# ================================
# INVOKING INITLEDGER IN CHAINCODE
# ================================
#docker exec "$CLI_NAME" peer chaincode invoke -o "$ORDERER_NAME":7050 --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n $CC_NAME -c '{"Args":["initLedger"]}'
