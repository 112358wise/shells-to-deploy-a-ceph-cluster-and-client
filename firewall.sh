#!/usr/bin
#open firewall ports for ceph

iface=${iface:-""}
ip_address=${ip_address:-""}
netmask=${netmask:-""}

example()
{
    echo $"$0: Usage: $0 <iface> <ip_address> <netmask>"
}

if [ $# -lt 3 ]; then
    example
    exit 1
fi

iface="$1"
ip_address="$2"
netmask="$3"

sudo iptables -A INPUT -i ${iface} -p tcp -s ${ip_address}/${netmask} --dport 6789 -j ACCEPT
