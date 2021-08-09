MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="

--==MYBOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash
/etc/eks/bootstrap.sh terraform-eks-cluster \
--use-max-pods false --kubelet-extra-args '--max-pods=7'
--kubelet-extra-args '--node-labels=eks.amazonaws.com/nodegroup=sample_node_grp, \
eks.amazonaws.com/nodegroup-image=ami-0ba9feae3dafa4606 \
--allowed-unsafe-sysctls=net.ipv4.tcp_keepalive_time, \
net.ipv4.tcp_keepalive_intvl,net.ipv4.tcp_keepalive_probes'

--==MYBOUNDARY==--\