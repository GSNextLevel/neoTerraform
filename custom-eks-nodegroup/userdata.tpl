MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="

--==MYBOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash
/etc/eks/bootstrap.sh ${CLUSTER_NAME} \
--use-max-pods false --kubelet-extra-args '
--node-labels=eks.amazonaws.com/nodegroup=${NODE_GROUP_NAME}, \
eks.amazonaws.com/nodegroup-image=${AMI_ID} \
--allowed-unsafe-sysctls=net.ipv4.tcp_keepalive_time, \
net.ipv4.tcp_keepalive_intvl,net.ipv4.tcp_keepalive_probes \
--max-pods=${MAX_PODS}'

--==MYBOUNDARY==--\
