export DEBIAN_FRONTEND=noninteractive

#installation of curl for http request for host-c test
sudo apt install -y curl

#Configuration of network interface to router-1
sudo ip addr add 192.168.2.2/30 dev enp0s9
sudo ip link set enp0s9 up

#Configuration of network interface to host-c
sudo ip addr add 192.168.4.1/23 dev enp0s8
sudo ip link set enp0s8 up

#Static routing to access host-a and host-b networks
#sudo ip route add 192.168.0.0/25 via 192.168.2.1 dev enp0s9
#sudo ip route add 192.168.1.0/24 via 192.168.2.1 dev enp0s9
sudo ip route add 192.168.0.0/23 via 192.168.2.1 dev enp0s9

#enable IP forwarding
sudo sysctl net.ipv4.ip_forward=1
