#!/bin/bash

set -e 
set -o xtrace

# 1> ceph-deploy install client_node && ceph-deploy admin client_node
# 2> convert image with QEMU
# 3> create user client.libvirt

client_node=${client_node:-""}

example()
{
	echo $"$0: Usage: $0 <client_node>"
}

if [ $# -lt 1 ];then
	example
	exit 1
fi

client_node="$1"

SHDIR=$(cd "$(dirname "$0")" & pwd)
cd ..
cd my-cluster
CLUDIR=$(cd "$(dirname "$0")" & pwd)

source $SHDIR/hostrc
# make sure client suits OS Recommendation
ceph-deploy install $client_node
ceph-deploy admin $client_node

# create image with QEMU

ssh $ceph_user@$client_node "qemu-img convert -f qcow2 -O raw /var/lib/image/qcow2/ubuntu-ceph2.qcow2 rbd:rbd/foo1"
ssh $ceph_user@$client_node "qemu-img info rbd:rbd/foo1"

# create user client.libvirt
ceph auth get-or-create client.libvirt mon 'allow r' osd 'allow class-read object_prefix rbd_children, allow rwx pool=rbd'

ceph auth list


set +o xtrace

