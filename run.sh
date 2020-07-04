#!/bin/bash
#######################
##  by jeozey 594485991@qq.com
#######################

FABRIC_VERSION=1.4.6
export IMAGE_TAG=latest
export COMPOSE_PROJECT_NAME=test

function installPkg(){

	##### install docker-ce
	if ! [ -x "$(command -v docker)" ]; then
		echo "install docker-ce..."
		sudo yum install -y yum-utils device-mapper-persistent-data lvm2
		sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
		sudo yum install -y docker-ce
		sudo systemctl start docker && sudo systemctl daemon-reload && sudo systemctl enable docker && docker -v
	fi

	##### install docker-compose
	if ! [ -x "$(command -v docker-compose)" ]; then
		echo "install docker-compose..."
		sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
		sudo chmod +x /usr/local/bin/docker-compose
	fi

	##### down fabric binary tool
	if [ ! -f ./bin/cryptogen ]; then
		curl -sSL http://bit.ly/2ysbOFE | bash -s $FABRIC_VERSION -s
	fi 

}

#start fabric network
function startNetWork(){
	installPkg
	
	#generate encryption certificate 
	rm -rf channel-artifacts crypto-config
	mkdir channel-artifacts
	./bin/cryptogen generate --config=./crypto-config.yaml	
	
	#generate orderer genesis block
	./bin/configtxgen -profile SoloOrdererGenesis -channelID byfn-sys-channel -outputBlock ./channel-artifacts/genesis.block
	
	#generate channel tx config
	export CHANNEL_NAME=mychannel
	./bin/configtxgen -profile MyChannel -outputCreateChannelTx ./channel-artifacts/${CHANNEL_NAME}_channel.tx -channelID $CHANNEL_NAME
	./bin/configtxgen -profile MyChannel -outputAnchorPeersUpdate ./channel-artifacts/${CHANNEL_NAME}_Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP
	./bin/configtxgen -profile MyChannel -outputAnchorPeersUpdate ./channel-artifacts/${CHANNEL_NAME}_Org2MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org2MSP
	
	#start network
	docker-compose -f docker-compose-cli.yaml up -d
	
	#sleep 100
	
	#create channel 、 join channel 、 install chaincode 、instantiate chaincode and check chaincode
	chmod +x ./scripts/init.sh
	docker exec  cli bash -c './scripts/init.sh'
}

function stopNetWork(){
	docker-compose -f docker-compose-cli.yaml down --volumes --remove-orphans
}
#Print the usage message
function printHelp () {
  echo "Usage: "
  echo "   sh run.sh start|stop "
}

if [ $# -ne 1 ];
then
	printHelp
	exit
fi

if [ $1 == "start" ] ; then	
	startNetWork
elif [ $1 == "stop" ] ; then
	stopNetWork
else 
	printHelp
fi