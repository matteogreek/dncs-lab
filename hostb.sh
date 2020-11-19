export DEBIAN_FRONTEND=noninteractive

#installation of curl for http request for host-c test
sudo apt install -y curl

#Configuration of network interface
sudo ip addr add 192.168.1.2/24 dev enp0s8
sudo ip link set enp0s8 up
#Setting up default gateway
sudo ip route add default via 192.168.1.1