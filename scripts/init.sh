export CHANNEL_NAME=mychannel
peer channel create -o orderer0.orderer.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/${CHANNEL_NAME}_channel.tx 
peer channel join -b ${CHANNEL_NAME}.block 
peer channel update -o orderer0.orderer.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/${CHANNEL_NAME}_Org1MSPanchors.tx

peer chaincode install -n mycc -v 1.0 -p github.com/chaincode/sacc/
peer chaincode list --installed


#change to org2MSP
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
CORE_PEER_ADDRESS=peer0.org2.example.com:7051
CORE_PEER_LOCALMSPID="Org2MSP"

#org2 join channel and install chaincode
peer channel join -b ${CHANNEL_NAME}.block 
peer channel update -o orderer0.orderer.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/${CHANNEL_NAME}_Org2MSPanchors.tx
peer chaincode install -n mycc -v 1.0 -p github.com/chaincode/sacc/

peer chaincode instantiate  -C $CHANNEL_NAME -n mycc -v 1.0 -c '{"Args":["a","10"]}'  -P  "OR ('Org1MSP.peer','Org2MSP.peer')" -o orderer0.orderer.example.com:7050

#chaincode instantiate need some time
sleep 10

peer chaincode list --instantiated  -C $CHANNEL_NAME 

peer chaincode invoke -o orderer0.orderer.example.com:7050  -C $CHANNEL_NAME -n mycc  -c '{"Args":["set","hello","wellcome to fabric"]}'
sleep 2
peer chaincode query -C $CHANNEL_NAME -n mycc -c '{"Args":["query","hello"]}'