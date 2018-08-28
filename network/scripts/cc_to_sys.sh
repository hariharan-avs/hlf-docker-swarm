#!/bin/bash

# rm -R /var/mynetwork/chaincode/*
mkdir -p /var/mynetwork/chaincode_simple
cp -R ../../chaincode_simple/* /var/mynetwork/chaincode_simple/
mkdir -p /var/mynetwork/chaincode_smallbank
cp -R ../../chaincode_smallbank/* /var/mynetwork/chaincode_smallbank/
