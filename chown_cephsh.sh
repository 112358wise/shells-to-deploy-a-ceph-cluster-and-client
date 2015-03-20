#!/bin/bash
set -e
set -o xtrace

chown -R vceph:vceph /root/ceph
mv /root/ceph /home/vceph/ceph

su - vceph

set +o xtrace
