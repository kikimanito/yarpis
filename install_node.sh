# Copy of https://github.com/rioda-org/idena/blob/main/raspberry_pi/build_for_64bit, with some modifications

# Check if your os is 64-bit by running uname -u command
# if it does not have aarch64 in output, it's 32-bit OS
# I have installed ubuntu server for Pi from here
# https://ubuntu.com/download/raspberry-pi
# Find out what is ip address of your PI
# I will use 192.168.0.5 for example

# ssh ubuntu@192.168.0.5
# pass: ubuntu
# change pass as instructed

sudo apt update && apt upgrade -y
sudo reboot now

# install go
wget https://golang.org/dl/go1.17.2.linux-arm64.tar.gz
sudo tar -C /usr/local -xzf go1.17.2.linux-arm64.tar.gz
rm go1.17.2.linux-arm64.tar.gz

# setup path for go
echo "PATH=$PATH:/usr/local/go/bin
GOPATH=$HOME/go" >> ~/.profile
source ~/.profile

# install go c compiler
sudo apt install gcc -y

# check if go and c installed ok
go version
gcc -v

# setup 1GB of swap
sudo fallocate -l 1G /swapfile2 && sudo chmod 600 /swapfile2 && sudo mkswap /swapfile2 && sudo swapon /swapfile2 && echo "/swapfile2 none swap sw 0 0" | sudo tee -a /etc/fstab

git clone https://github.com/idena-network/idena-go.git
cd idena-go/
git pull
git checkout tags/v1.0.2 -b v1.0.2
git pull
go build -ldflags "-X main.version=1.0.2"
cd ..

# put your apikey below
screen -dmS idena ./idena-go --rpcaddr=0.0.0.0 --apikey=123

# Ensure you have enabled 9009 port in the firewall: 
sudo ufw allow 9009

# Now you can connect Desktop app to your node using parameters 
# Node address: http://192.168.0.5:9009
# Node api key: 123
# If you already have your node you need to put your nodekey in /datadir/keystore directory
# As per guide: https://www.idena.io/guide#guide-issues-3, remote node logs can be found in the same directory where the Idena node is located: ./datadir/logs/output.log
