echo NOMAD_DATACENTER=${NOMAD_DATACENTER} | tee -a /etc/environment
echo NOMAD_REGION=${NOMAD_REGION} | tee -a /etc/environment
echo NOMAD_ADDR=${NOMAD_ADDR} | tee -a /etc/environment
 
unzip nomad.zip -d /bin \
&& chmod +x /bin/nomad

mkdir --parents /opt/nomad \
&& mkdir --parents /etc/nomad.d \
&& chmod 700 /etc/nomad.d \
&& touch /etc/nomad.d/nomad.hcl \
&& echo "datacenter=\"${NOMAD_DATACENTER}\"" >> /etc/nomad.d/nomad.hcl \
&& echo "region=\"${NOMAD_REGION}\"" >> /etc/nomad.d/nomad.hcl \
&& echo 'data_dir = "/opt/nomad"' >> /etc/nomad.d/nomad.hcl

cp client.hcl /etc/nomad.d/client.hcl \
&& sed -i "s/SERVER_ADDRESS/$NOMAD_ADDR/g" /etc/nomad.d/client.hcl

mkdir --parents /var/tls \
&& cp ca-key.pem /var/tls/ca-key.pem \
&& cp client-key.pem /var/tls/client-key.pem \
&& cp client.pem /var/tls/client.pem

cp nomad.service /etc/systemd/system/nomad.service \
&& systemctl enable nomad \
&& systemctl start nomad \
&& systemctl status nomad