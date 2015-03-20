INSTALLATION(QUICK)

STEP1:PREFLIGHT CHECKLIST

on all ceph nodes:
        bash sshpermitroot.sh (run at root)
                # 1> ssh permit Root login
                # 2> add apt proxy
                # 3> add a user for ceph (vceph) exp_vceph.sh
                # 4> change owner of ceph shell direcory
                (exit at vceph)
        bash ceph.sh .... (run at root)
                # 1> add nopasswd sudo to vceph
                # 2> add apt proxy && wget proxy
                # 3> add release key, ceph packages
                # 4> install ceph-deploy ntp openssh-server
        bash firewall.sh ....
                # 1> add port 6789
on admin node:
        config /etc/hosts (run at root)
                # 1> add all ceph nodes
        bash exp_ssh.sh (run at vceph)
                # 1> generate ssh key
                # 3> add release key, ceph packages
                # 4> install ceph-deploy ntp openssh-server
        bash firewall.sh ....
                # 1> add port 6789
on admin node:
        config /etc/hosts (run at root)
                # 3> add release key, ceph packages
                # 4> install ceph-deploy ntp openssh-server
        bash firewall.sh ....
                # 1> add port 6789
on admin node:
        config /etc/hosts (run at root)
                # 1> add all ceph nodes
        bash exp_ssh.sh (run at vceph)
                # 1> generate ssh key
        edit ssh_id.sh acordingly (about user@host)
        && bash ssh_id.sh (run at vceph)
                # 1> copy ssh key from admin node to ceph nodes
                # 2> set ~/.wgetrc of all nodes

STEP2:STORAGE CLUSETER QUICK START

on admin node:
        edit /home/vceph/ceph/hostrc
        bash cluster-deploy.sh (run at vceph)
                # 1> cd my_cluster
                # 2> deploy a cluster with 1 monitor and 2 osds
                # 4> expand the cluster by add 1 osd and 1 mds(metadata server)
                so the final cluster is with 1 mon 3 osds and 1mds

STEP3: BLOCK DEVICE QUICK START
STEP4: USING libvirt WITH CEPH RBD

# make sure client suits OS Recommendation
        bash client_deploy.sh (run at vceph)
                # 1> ceph-deploy install client_node
                  && ceph-deploy admin client_node
                # 2> convert image with QEMU
                # 3> create user client.libvirt
        bash chg_xml.sh
                # 1> generate a secret
                # 2> config the VM xml
                # 3> start the VM
