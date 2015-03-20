#!/bin/bash
#ssh copy id

# 1> copy key from admin node to ceph nodes
# 2> set ~/.wgetrc of all nodes

ssh-copy-id vceph@vceph00
ssh-copy-id vceph@vceph01
ssh-copy-id vceph@vceph02
ssh-copy-id vceph@vceph03
ssh-copy-id vceph@client

wget_proxy()
{
    cat <<'EOF' > ".wgetrc"
http_proxy=http://proxy-shm.intel.com:911
https_proxy=https://proxy-shm.intel.com:911
EOF
}
wget_proxy

scp .wgetrc vceph@vceph00:~
scp .wgetrc vceph@vceph01:~
scp .wgetrc vceph@vceph02:~
scp .wgetrc vceph@vceph03:~
scp .wgetrc vceph@client:~
