#!/bin/bash
yum update -y
curl https://rpm.gremlin.com/gremlin.repo -o /etc/yum.repos.d/gremlin.repo
yum install -y gremlin gremlind
export INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
echo '${GREMLIN_CERTIFICATE}' >> /var/lib/gremlin/pub_cert.pem
echo '${GREMLIN_PRIVATE_KEY}' >> /var/lib/gremlin/priv_key.pem
sed -i '/#team_id/c\team_id: ${GREMLIN_TEAM_ID}' /etc/gremlin/config.yaml
sed -i '/#team_certificate/c\team_certificate: file:///var/lib/gremlin/pub_cert.pem' /etc/gremlin/config.yaml
sed -i '/#team_private_key/c\team_private_key: file:///var/lib/gremlin/priv_key.pem' /etc/gremlin/config.yaml
gremlin init -s autoconnect --tag instance_id=$INSTANCE_ID --tag owner=SET_OWNER