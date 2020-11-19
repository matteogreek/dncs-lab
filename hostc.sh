export DEBIAN_FRONTEND=noninteractive

#Installation of curl for http request and docker installation 
sudo apt install -y curl 

#Installation of docker 
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
#Add Docker’s official GPG key:
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update

#install the latest version of Docker Engine and containerd
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
#pull and run nginx-test from docker-hub
sudo docker pull dustnic82/nginx-test
sudo docker run -d -p 80:80 dustnic82/nginx-test

#Configuration of network interface
sudo ip addr add 192.168.4.2/23 dev enp0s8
sudo ip link set enp0s8 up
#Setting up default gateway
sudo ip route add default via 192.168.4.1