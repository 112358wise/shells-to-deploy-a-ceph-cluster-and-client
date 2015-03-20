#!/bin/bash
set -e
set -o xtrace
# from root to the ceph user
# 1> ssh permit Root login
# 2> config /etc/apt/apt.conf
# 3> add a user for ceph (vceph) exp_vceph.sh
# 4> change owner of ceph shell direcory
TOPDIR=$(cd "$(dirname "$0")" && pwd)

sed -i "s/PermitRootLogin without-password/PermitRootLogin yes/g" /etc/ssh/sshd_config
service ssh restart
sudo useradd -m vceph

cat << 'EOF' > /etc/apt/apt.conf
Acquire::http::proxy "http://proxy-shm.intel.com:911";
Acquire::https::proxy "http://proxy-shm.intel.com:911";
Acquire::ftp::proxy "http://proxy-shm.intel.com:911";
EOF

apt-get install expect

expect $TOPDIR/exp_vceph.sh

chown -R vceph:vceph /root/ceph
mv /root/ceph /home/vceph/ceph

su - vceph

set +o xtrace
