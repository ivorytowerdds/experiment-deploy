#!/bin/bash -x
echo "Run Instances starts" >> tmplog

echo "Update systcl" >> tmplog
sudo sysctl -w net.core.somaxconn=1024
sudo sysctl -w net.core.netdev_max_backlog=65536
sudo sysctl -w net.ipv4.tcp_tw_reuse=1
sudo sysctl -w net.ipv4.tcp_rmem='4096 65536 16777216'
sudo sysctl -w net.ipv4.tcp_wmem='4096 65536 16777216'
sudo sysctl -w net.ipv4.tcp_mem='65536 131072 262144'

echo "Setup path" >> tmplog
./kill_node.sh
MyHOME=/home/ec2-user
source ~/.bash_profile
export GOROOT=/usr/lib/golang
export GOPATH=$MyHOME/projects
export PATH=$PATH:$GOROOT/bin

echo "Get ip" >> tmplog
# Get my IP
wget http://169.254.169.254/latest/meta-data/public-ipv4
ip=$(head -n 1 public-ipv4)
echo "Current IP is >>>"
echo $ip
echo ">>>>"

echo "Run soldier" >> tmplog
# Run soldier
cd $GOPATH/src/harmony-benchmark/bin/
node_port=9000
./soldier -ip $ip -port $node_port > soldier_log 2>&1 &

echo "Run Instances done" >> tmplog
