#!/bin/bash

echo -e "┌────────────────────────────────────────────────┐"
echo -e "│                                                │"
echo -e "│      ___    ____  ______                __     │"
echo -e "│     /   |  / __ \/ ____/___  ____  ____/ /__   │"
echo -e "│    / /| | / /_/ / /   / __ \/ __ \/ __  / _ \  │"
echo -e "│   / ___ |/ _, _/ /___/ / / / /_/ / /_/ /  __/  │"
echo -e "│  /_/  |_/_/ |_|\____/_/ /_/\____/\__,_/\___/   │"
echo -e "│                                                │"
echo -e "└────────────────────────────────────────────────┘"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

COIN_NAME='ARC'
COIN_DAEMON='arcticcoind'
COIN_CLIENT='arcticcoin-cli'
COIN_FOLDER='.arcticcore'
COIN_CONFIG='arcticcoin.conf'
COIN_BINARIES_URL='https://github.com/ArcticCore/arcticcoin/releases/download/v0.12.1.2/arcticcore-0.12.2-linux64.tar.gz'
COIN_ARCHIVE='arcticcore-0.12.2-linux64.tar.gz'


# Check if package is installed and if not, deploy it
function package_check {
	dpkg -s $1 &> /dev/null

	if [ $? -eq 0 ]; then
		echo "Package $1 is installed!"
    	else
		echo "Package $1 is NOT installed!"
		apt install $1 -y
	fi
}


# Pre-requirements check
function prereq_check {
	echo -e "${GREEN}Checking required packages${NC}"
	package_check curl
	package_check wget
	package_check pwgen
}


# Download and unpack binaries
function install_binaries {
    echo -e "${GREEN}Downloading and installing binaries for ${COIN_NAME}${NC}"
    echo ""
    mkdir /tmp/${COIN_NAME}_deploy
    cd /tmp/${COIN_NAME}_deploy
    wget ${COIN_BINARIES_URL}
    tar -xvf ${COIN_ARCHIVE}
    cd arcticcore-0.12.1
    cp -R * /usr/local
    rm -rf /tmp/${COIN_NAME}_deploy
}


# Install service
function add_service {
    echo -e "${GREEN}Adding ${COIN_DAEMON}.service to systemd${NC}"
    echo ""
    echo \
    "[Unit]
Description=${COIN_NAME} Coin Service
After=network.target

[Service]
User=root
Group=root
Type=forking
PIDFile=/root/${COIN_FOLDER}/${COIN_DAEMON}.pid
ExecStart=/usr/local/bin/${COIN_DAEMON} -daemon -conf=/root/${COIN_FOLDER}/${COIN_CONFIG} -datadir=/root/${COIN_FOLDER}
ExecStop=/usr/local/bin/${COIN_CLIENT} -conf=/root/${COIN_FOLDER}/${COIN_CONFIG} -datadir=/root/${COIN_FOLDER} stop
Restart=always
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=10s
StartLimitInterval=120s
StartLimitBurst=5

[Install]
WantedBy=multi-user.target
Alias=${COIN_DAEMON}.service" | tee /lib/systemd/system/${COIN_DAEMON}.service
    chmod 664 /lib/systemd/system/${COIN_DAEMON}.service
    systemctl enable /lib/systemd/system/${COIN_DAEMON}.service
}


# Create Masternode configuration
function generate_masternode_configuration {
    echo -e "${GREEN}Creating ${COIN_CONFIG}${NC}"
    echo ""
    mkdir /root/${COIN_FOLDER}
    echo \
    "rpcuser=aRct1Cisdfv87jn34rn
rpcpassword=7bmrV3MMM6z63NJ878sdjLKJ83VR66Bq74iH2SVxw9xf6x
rpcallowip=127.0.0.1
server=1
listen=1
daemon=1
goldminenode=1 
goldminenodeprivkey=<PRIVATE_KEY> 
externalip=`curl ipinfo.io/ip`
addnode=80.211.97.10
addnode=194.182.83.176
addnode=77.55.194.116
addnode=77.55.194.101
addnode=77.55.194.106
addnode=77.55.219.230
addnode=77.55.194.141
addnode=1.232.41.78:55640
addnode=104.129.5.8:33296
addnode=104.129.5.8:37032
addnode=104.129.5.8:37532
addnode=104.129.5.8:40044
addnode=104.129.5.8:48088
addnode=104.129.5.8:53522
addnode=104.129.5.8:53734
addnode=104.129.5.8:56600
addnode=104.129.5.8:57272
addnode=104.129.5.8:7209
addnode=104.189.30.198:58681
addnode=104.248.181.138:46154
addnode=104.254.90.82:56829
addnode=107.150.7.213:59620
addnode=108.61.165.84:48176
addnode=108.61.165.84:7209
addnode=108.61.188.162:7209
addnode=109.195.38.175:47970
addnode=109.234.37.120:35318
addnode=109.234.37.120:7209
addnode=115.68.207.34:7209
addnode=115.68.232.166:60710
addnode=115.68.232.166:7209
addnode=136.144.179.49:52010
addnode=136.243.83.33:51050
addnode=144.202.49.240:34178
addnode=144.202.49.240:42300
addnode=144.202.49.240:48096
addnode=144.202.49.240:54588
addnode=144.202.49.240:7209
addnode=151.80.45.170:7209
addnode=159.69.3.219:38598
addnode=159.69.3.219:48408
addnode=159.69.35.169:44022
addnode=159.69.35.169:57454
addnode=159.69.35.169:7209
addnode=159.69.35.170:35332
addnode=159.69.35.170:7209
addnode=159.69.8.63:48612
addnode=159.69.8.63:7209
addnode=164.132.159.67:43220
addnode=173.212.225.176:62975
addnode=173.249.33.29:46720
addnode=173.249.33.29:47522
addnode=173.249.33.29:7209
addnode=174.93.242.120:62314
addnode=176.12.60.95:18081
addnode=176.12.60.95:49836
addnode=176.12.60.95:63280
addnode=176.12.60.95:7585
addnode=176.12.60.95:8173
addnode=176.139.5.88:61957
addnode=176.31.205.41:7209
addnode=178.150.48.87:33384
addnode=178.234.41.228:59274
addnode=178.254.24.11:54222
addnode=185.102.188.243:43549
addnode=185.102.188.243:57484
addnode=185.105.208.214:42170
addnode=185.105.208.214:7209
addnode=185.162.250.219:49844
addnode=185.162.250.219:53810
addnode=185.162.250.219:55008
addnode=185.162.250.219:7209
addnode=185.205.210.156:42858
addnode=185.205.210.156:7209
addnode=185.205.210.194:7209
addnode=185.206.144.166:49130
addnode=185.206.144.166:7209
addnode=185.240.242.188:7209
addnode=185.249.254.4:7209
addnode=185.250.207.46:59555
addnode=188.166.166.139:51156
addnode=188.40.78.31:58850
addnode=190.146.185.9:63741
addnode=192.241.225.103:39396
addnode=194.158.216.144:57687
addnode=194.182.83.176:42064
addnode=194.182.83.176:7209
addnode=194.87.234.204:46506
addnode=195.201.142.22:40490
addnode=195.201.226.82:46192
addnode=195.201.226.82:51394
addnode=195.201.226.84:36220
addnode=195.201.226.84:7209
addnode=195.201.42.223:44092
addnode=195.201.42.223:59604
addnode=195.201.42.231:55098
addnode=204.44.75.239:40030
addnode=204.44.75.239:45154
addnode=204.44.75.239:7209
addnode=207.180.215.128:7209
addnode=207.246.113.190:46420
addnode=209.250.228.117:36694
addnode=212.180.241.135:2128
addnode=212.180.241.135:2129
addnode=212.237.12.5:53782
addnode=217.145.91.6:27547
addnode=217.145.91.6:27549
addnode=217.145.91.6:27576
addnode=217.145.91.6:27600
addnode=217.145.91.6:27658
addnode=217.145.91.6:27722
addnode=217.145.91.6:27725
addnode=217.145.91.6:7209
addnode=23.97.160.36:47512
addnode=23.97.160.36:47676
addnode=23.97.160.36:48136" | tee /root/${COIN_FOLDER}/${COIN_CONFIG}
}


# Display installation summary
function display_summary {
	echo "${GREEN}Node installation finished.${NC}"
}


prereq_check
install_binaries
add_service
generate_masternode_configuration
display_summary
