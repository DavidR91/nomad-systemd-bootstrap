echo NOMAD_DATACENTER=${NOMAD_DATACENTER} | tee -a /etc/environment
echo NOMAD_REGION=${NOMAD_REGION} | tee -a /etc/environment
echo NOMAD_IP=${NOMAD_IP} | tee -a /etc/environment
echo NOMAD_PORT=${NOMAD_PORT} | tee -a /etc/environment
echo NOMAD_ADDR=${NOMAD_ADDR} | tee -a /etc/environment
 
# Add the server to the hosts file
echo "${NOMAD_IP}  ${NOMAD_ADDR}" | tee -a /etc/hosts

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
&& sed -i "s/SERVER_ADDRESS/$NOMAD_ADDR:$NOMAD_PORT/g" /etc/nomad.d/client.hcl

mkdir --parents /var/tls \
&& chmod 700 /var/tls \
&& cp ca-key.pem /var/tls/ca-key.pem \
&& cp client-key.pem /var/tls/client-key.pem \
&& cp client.pem /var/tls/client.pem

cp nomad.service /etc/systemd/system/nomad.service \
&& systemctl enable nomad \
&& systemctl start nomad \
&& systemctl status nomad

# Cleanup
rm bootstrap.sh bootstrap-internetconnected.sh ca-key.pem client.hcl client.pem client-key.pem nomad.service nomad.zip