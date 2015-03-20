#!/bin/bash

set -e
set -o xtrace
# 1> cd my_cluster
# 2> ceph-deploy new monitor && ceph-deploy install admin_node ceph_nodes ... && ceph-deploy mon create-initial && ceph-deploy admin admin_node ceph_nodes ...  
# 3> prepare and add osds 

initial_monitor=${initial_monitor:-""}

example()
{
    echo $"$0: Usage: $0 <initial_monitor>"
}

if [ $# -lt 1 ]; then
    example
    exit 1
fi

initial_monitor="$1"

# shell script dir
SHDIR=$(cd "$(dirname "$0")" && pwd)
cd ..
if [ -d my-cluster ];then
	rm -rf my-cluster
fi

mkdir my-cluster
cd my-cluster
# cluster directory on admin node for maintaining conf files
cLUDIR=$(cd "$(dirname "$0")"&& pwd)

admin_node=`hostname`
ceph_nodes_list=`cat /etc/hosts | grep 10 | awk '{print $1}' | sort -u | tr "\n" " "`

ceph-deploy new $initial_monitor

echo "osd_pool_default_size = 2" >> ceph.conf

#ceph-deploy install $ceph_nodes_list

ceph-deploy mon create-initial

# prepare and add osds

source $SHDIR/hostrc
num=0
ceph_user=vceph
for hn in $storage_nodes_list; do
        if [[ `hostname -I | grep $hn | wc -l` -gt 0 ]]; then
                continue
        fi
        ssh $ceph_user@$hn "sudo mkdir /var/local/osd$num"
        num=`expr $num + 1`
done
next_num=$num

num=0
for hn in $storage_nodes_list; do
	if [[ `hostname -I | grep $hn | wc -l` -gt 0 ]]; then
		continue
	fi
	ceph-deploy osd prepare $hn:/var/local/osd$num
	ceph-deploy osd activate $hn:/var/local/osd$num
	num=`expr $num + 1`
done

ceph-deploy admin $ceph_nodes_list

# expand a cluster
# add an OSD and a Metadata Server to moniter

ssh $ceph_user@$initial_monitor "sudo mkdir /var/local/osd$next_num"
ceph-deploy osd prepare $initial_monitor:/var/local/osd$next_num
ceph-deploy osd activate $initial_monitor:/var/local/osd$next_num

ceph-deploy mds create $initial_monitor

next_num=`expr $next_num + 1`


set +o xtrace
