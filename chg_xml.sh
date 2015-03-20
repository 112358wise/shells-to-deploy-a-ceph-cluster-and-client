#!/bin/bash

# 1> generate a secret
# 2> config the VM xml 
# 3> start the VM xml
set -e
set -o xtrace

SHDIR=$(cd "$(dirname "$0")" & pwd)

source $SHDIR/hostrc

cp abc_base abc1
sed -i "s/abc_base/abc1/g" abc1
sed -i "s/rbd\/foo/rbd\/foo1/g" abc1
sed -i "s/{monitor_ip}/$monitor_ip/g" abc1

#generate a secret
cat > secret.xml <<EOF
<secret ephemeral='no' private='no'>
        <usage type='ceph'>
                <name>client.libvirt secret</name>
        </usage>
</secret>
EOF

sudo virsh secret-define --file secret.xml > txt
secret_uuid=`awk '{print $2}' txt`
ceph auth get-key client.libvirt | sudo tee client.libvirt.key
sudo virsh secret-set-value --secret $secret_uuid --base64 $(cat client.libvirt.key) && rm -rf client.libvirt.key secret.xml

sed -i "s/{secret_uuid}/$secret_uuid/g" abc1

sudo virsh define abc1
sudo virsh start abc1
sudo virsh list --all
sudo virsh vncdisplay abc1

set +o xtrace
