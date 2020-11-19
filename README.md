# DNCS-LAB

This repository contains the Vagrant files required to run the virtual lab environment used in the DNCS course.
```


        +-----------------------------------------------------+
        |                                                     |
        |                                                     |eth0
        +--+--+                +------------+             +------------+
        |     |                |            |             |            |
        |     |            eth0|            |eth2     eth2|            |
        |     +----------------+  router-1  +-------------+  router-2  |
        |     |                |            |             |            |
        |     |                |            |             |            |
        |  M  |                +------------+             +------------+
        |  A  |                      |eth1                       |eth1
        |  N  |                      |                           |
        |  A  |                      |                           |
        |  G  |                      |                     +-----+----+
        |  E  |                      |eth1                 |          |
        |  M  |            +-------------------+           |          |
        |  E  |        eth0|                   |           |  host-c  |
        |  N  +------------+      SWITCH       |           |          |
        |  T  |            |                   |           |          |
        |     |            +-------------------+           +----------+
        |  V  |               |eth2         |eth3                |eth0
        |  A  |               |             |                    |
        |  G  |               |             |                    |
        |  R  |               |eth1         |eth1                |
        |  A  |        +----------+     +----------+             |
        |  N  |        |          |     |          |             |
        |  T  |    eth0|          |     |          |             |
        |     +--------+  host-a  |     |  host-b  |             |
        |     |        |          |     |          |             |
        |     |        |          |     |          |             |
        ++-+--+        +----------+     +----------+             |
        | |                              |eth0                   |
        | |                              |                       |
        | +------------------------------+                       |
        |                                                        |
        |                                                        |
        +--------------------------------------------------------+



```

# Requirements
 - Python 3
 - 10GB disk storage
 - 2GB free RAM
 - Virtualbox
 - Vagrant (https://www.vagrantup.com)
 - Internet

# How-to
 - Install Virtualbox and Vagrant
 - Clone this repository
`git clone https://github.com/fabrizio-granelli/dncs-lab`
 - You should be able to launch the lab from within the cloned repo folder.
```
cd dncs-lab
[~/dncs-lab] vagrant up
```
Once you launch the vagrant script, it may take a while for the entire topology to become available.
 - Verify the status of the 4 VMs
 ```
 [dncs-lab]$ vagrant status                                                                                                                                                                
Current machine states:

router                    running (virtualbox)
switch                    running (virtualbox)
host-a                    running (virtualbox)
host-b                    running (virtualbox)
```
- Once all the VMs are running verify you can log into all of them:
`vagrant ssh router`
`vagrant ssh switch`
`vagrant ssh host-a`
`vagrant ssh host-b`
`vagrant ssh host-c`

# Assignment
This section describes the assignment, its requirements and the tasks the student has to complete.
The assignment consists in a simple piece of design work that students have to carry out to satisfy the requirements described below.
The assignment deliverable consists of a Github repository containing:
- the code necessary for the infrastructure to be replicated and instantiated
- an updated README.md file where design decisions and experimental results are illustrated
- an updated answers.yml file containing the details of your project

## Design Requirements
- Hosts 1-a and 1-b are in two subnets (*Hosts-A* and *Hosts-B*) that must be able to scale up to respectively 87 and 227 usable addresses
- Host 2-c is in a subnet (*Hub*) that needs to accommodate up to 397 usable addresses
- Host 2-c must run a docker image (dustnic82/nginx-test) which implements a web-server that must be reachable from Host-1-a and Host-1-b
- No dynamic routing can be used
- Routes must be as generic as possible
- The lab setup must be portable and executed just by launching the `vagrant up` command

## Tasks
- Fork the Github repository: https://github.com/fabrizio-granelli/dncs-lab
- Clone the repository
- Run the initiator script (dncs-init). The script generates a custom `answers.yml` file and updates the Readme.md file with specific details automatically generated by the script itself.
  This can be done just once in case the work is being carried out by a group of (<=2) engineers, using the name of the 'squad lead'. 
- Implement the design by integrating the necessary commands into the VM startup scripts (create more if necessary)
- Modify the Vagrantfile (if necessary)
- Document the design by expanding this readme file
- Fill the `answers.yml` file where required (make sure that is committed and pushed to your repository)
- Commit the changes and push to your own repository
- Notify the examiner (fabrizio.granelli@unitn.it) that work is complete specifying the Github repository, First Name, Last Name and Matriculation number. This needs to happen at least 7 days prior an exam registration date.

# Notes and References
- https://rogerdudler.github.io/git-guide/
- http://therandomsecurityguy.com/openvswitch-cheat-sheet/
- https://www.cyberciti.biz/faq/howto-linux-configuring-default-route-with-ipcommand/
- https://www.vagrantup.com/intro/getting-started/


# Design
## Assigning hosts addresses
- "Hosts-A" is the subnet containing host-a. According to design requirements the subnet must be able to scale up to respectively **87** usable addresses. So **7** bits are needed for hosts (**2^7 = 128**). The netmask is 255.255.255.128 (/25), the network address is 192.168.0.0. In detail:

```
Address:   192.168.0.0           
Netmask:   255.255.255.128 = 25  
Wildcard:  0.0.0.127             
=>
Network:   192.168.0.0/25        
Broadcast: 192.168.0.127         
HostMin:   192.168.0.1           
HostMax:   192.168.0.126         
Hosts/Net: 126 
```
- "Hosts-B" is the subnet containing host-b. According to design requirements must be able to scale up to respectively** 227** usable addresses. So **8** bits are needed for hosts (**2 ^ 8 = 256**). The netmask is 255.255.255.0 (/24), the network address is 192.168.1.0. In detail:

```
Address:   192.168.1.0           
Netmask:   255.255.255.0 = 24    
Wildcard:  0.0.0.255             
=>
Network:   192.168.1.0/24        
Broadcast: 192.168.1.255         
HostMin:   192.168.1.1           
HostMax:   192.168.1.254         
Hosts/Net: 254
```
- "Hub" is the subnet containing the host-c. According to design requirements must be able to scale up to respectively **397** usable addresses. So **9** bits are needed for hosts (**2 ^ 9 = 512**). The netmask is 255.255.254.0 (/23), the network address is 192.168.4.0. In detail:

```
Address:   192.168.4.0           
Netmask:   255.255.254.0 = 23    
Wildcard:  0.0.1.255             
=>
Network:   192.168.4.0/23        
Broadcast: 192.168.5.255         
HostMin:   192.168.4.1           
HostMax:   192.168.5.254         
Hosts/Net: 510
```
- The last subnet is the one that connects router-1 and router-2. The subnet has the purpose of connecting the two routers,** 2** bits will be enough for the hosts (**2 ^ 2 = 4**). The network mask is 255.255.255.252 (/30), the network address is 192.168.2.0.

```
Address:   192.168.2.0           
Netmask:   255.255.255.252 = 30  
Wildcard:  0.0.0.3               
=>
Network:   192.168.2.0/30        
Broadcast: 192.168.2.3           
HostMin:   192.168.2.1           
HostMax:   192.168.2.2           
Hosts/Net: 2  
```
##Network map from cisco
After assigning the addresses to the hosts we used Cisco Packet Tracer software to create a visual representation of the network. We have configured each component to verify the correct functioning of the network before setting the individual virtual machines by vagrant.
![image](/util/cisco_img.png)

##VLAN
To configure the Hosts-a and Hosts-b subnets using the only physical interface between the router and the switch (given by the model provided) we chose to use the VLANs and to divide the single physical interface into two sub-interfaces. 
- Hosts-a belongs to **VLAN 10**
- Hosts-b belongs to **VLAN 20** 

The switch ports for using VLANs have been set as follow:
- Ports to hosts-a set to** access mode**
- Ports to hosts-b set to **access mode**
- Port to router-1 set to **trunk mode**

##Editing vagrantfile 
All Vagrant configuration is done in the file called *Vagrantfile*, it contains the settings of each virtual machine.
Example:

``` 
  config.vm.define "host-a" do |hosta|
  hosta.vm.box = "ubuntu/bionic64"
  hosta.vm.hostname = "host-a"
  hosta.vm.network "private_network", virtualbox__intnet: "broadcast_host_a", auto_config: false
  hosta.vm.provision "shell", path: "hosta.sh", run: 'always'
  hosta.vm.provider "virtualbox" do |vb|
  vb.memory = 256
    end
```
- Compared to all the other VMs we have changed the amount of vb.memory from **256MB** to **1024MB** since it must run a docker image (dustnic82/nginx-test) which implements a web-server.

- In addition, another change from the original vagrantfile is that we have created a specific script file for each VM where there are commands to configure the machine at each system start (vagrant up).

- Finally, we changed the call to the provisioner.
First, every provisioner is configured within Vagrantfile using the *config.vm.provision* method call.
 ` hosta.vm.provision "shell", path: "hosta.sh"`
 By default, provisioners are only run once, during the first vagrant up since the last vagrant destroy
Optionally, we can configure provisioners to run on every up or reload. To do this we have to set the run option to "always", as shown below:
 `hosta.vm.provision "shell", path: "hosta.sh", run: 'always'`

##File script list
As already described, each VM has a specific file script with all the configuration commands inside. In particular:

###Host-a: 
```
export DEBIAN_FRONTEND=noninteractive
#installation of curl for http request for host-c test
sudo apt install -y curl    
#Configuration of network interface
sudo ip addr add 192.168.0.2/25 dev enp0s8
sudo ip link set enp0s8 up
#Setting up default gateway
sudo ip route add default via 192.168.0.1 
```
###Host-b: 
```
export DEBIAN_FRONTEND=noninteractive
#installation of curl for http request for host-c test
sudo apt install -y curl
#Configuration of network interface
sudo ip addr add 192.168.1.2/24 dev enp0s8
sudo ip link set enp0s8 up
#Setting up default gateway
sudo ip route add default via 192.168.1.1
```
###Switch:
```
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

```
###Router-1:
```
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
```
###Router-2
```
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

```
Note: The static routing of router-2 in order to reach hosts-a and hosts-b we have decided to combine the two rules into one, making it as general as possible as required by the requirements of the project, so **"Routes must be as generic as possible ".**

###Host-c:
```
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
```
##Results
In conclusion, once logged into host-a, for example, we can verify the correct configuration by checking the host's IP address and then ping host-c to check reachability.
###Configuration and reachability
`Ifconfig -a`
![demo](/util/demo.gif)

###Web server 
First we check if the docker container with the nginx image is up and running 
![demo](/util/demo_server.gif)

Finally, to test the web server we use the curl command to make an http request. The server will respond by displaying the html page.
`curl http://192.168.4.2:80`
![image](/util/nginx_page.png)

