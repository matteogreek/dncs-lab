export DEBIAN_FRONTEND=noninteractive

#installation of curl for http request for host-c test
sudo apt install -y curl

#Configuration of network interface to router2
sudo ip addr add 192.168.2.1/30 dev enp0s9
sudo ip link set enp0s9 up

#Configuration of network interface to switch
sudo ip link set enp0s8 up

#Setting up subinterfaces for vlan

#First subinterface for vlan 10
sudo ip link add link enp0s8 name enp0s8.10 type vlan id 10
sudo ip addr add 192.168.0.1/25 dev enp0s8.10
sudo ip link set enp0s8.10 up
#Second subinterface for vlan 20
sudo ip link add link enp0s8 name enp0s8.20 type vlan id 20
sudo ip addr add 192.168.1.1/24 dev enp0s8.20
sudo ip link set enp0s8.20 up

#Static routing to access host-c network
sudo ip route add 192.168.4.0/23 via 192.168.2.2 dev enp0s9

#enable IP forwarding
sudo sysctl net.ipv4.ip_forward=1