#!/bin/bash
#prefilight ceph deploy ..
#
#   1. nopasswd sudo to {username}
#   2. set Intel apt_proxy wget_proxy
#   3. add release key, ceph packages
#   4. install ceph-deploy ntp openssh-server
#

ceph_user=${ceph_user:-""}

example()
{
    echo $"$0: Usage: $0 <ceph_user>"
}

if [ $# -lt 1 ]; then
    example
    exit 1
fi

ceph_user=$1

echo "$ceph_user ALL = (root) NOPASSWD:ALL" | \
    tee /etc/sudoers.d/$ceph_user
chmod 0440 /etc/sudoers.d/$ceph_user

apt_proxy()
{
    cat <<'EOF' > "/etc/apt/apt.conf"
Acquire::http::Proxy "http://proxy-shm.intel.com:911";
Acquire::https::Proxy "https://proxy-shm.intel.com:911";
EOF
}
apt_proxy

ceph_stable_release=${ceph_stable_release:-"cuttlefish"}
export http_proxy=http://proxy-shm.intel.com:911
export https_proxy=https://proxy-shm.intel.com:911
wget -q -O- 'https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc' | \
    apt-key add -
echo deb http://ceph.com/debian-${ceph_stable_release}/ $(lsb_release -sc) main | \
    tee /etc/apt/sources.list.d/ceph.list

apt-get clean all
apt-get update
apt-get install -y --force-yes ceph-deploy
apt-get install -y --force-yes ntp
apt-get install -y --force-yes openssh-server
