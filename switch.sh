export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y tcpdump
apt-get install -y openvswitch-common openvswitch-switch apt-transport-https ca-certificates curl software-properties-common


#Configuration of switch ports
sudo ovs-vsctl add-br switch
sudo ovs-vsctl add-port switch enp0s8
sudo ovs-vsctl add-port switch enp0s9 tag=10
sudo ovs-vsctl add-port switch enp0s10 tag=20

#setting trunk port towards router
sudo ovs-vsctl set port enp0s8 trunks=10,20

#Setting up links
sudo ip link set enp0s8 up
sudo ip link set enp0s9 up
sudo ip link set enp0s10 up

