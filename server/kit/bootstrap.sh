echo NOMAD_DATACENTER=${NOMAD_DATACENTER} | tee -a /etc/environment
echo NOMAD_REGION=${NOMAD_REGION} | tee -a /etc/environment

# We need nomad.zip and cfssl already extracted
unzip nomad.zip -d /bin \
&& chmod +x /bin/nomad 

chmod +x /bin/cfssl*

mkdir --parents /opt/nomad \
&& mkdir --parents /etc/nomad.d \
&& chmod 700 /etc/nomad.d \
&& touch /etc/nomad.d/nomad.hcl \
&& echo "datacenter=\"${NOMAD_DATACENTER}\"" >> /etc/nomad.d/nomad.hcl \
&& echo "region=\"${NOMAD_REGION}\"" >> /etc/nomad.d/nomad.hcl \
&& echo 'data_dir = "/opt/nomad"' >> /etc/nomad.d/nomad.hcl

cp server.hcl /etc/nomad.d/server.hcl \
&& sed -i "s/BOOTSTRAP_EXPECT/$BOOTSTRAP_EXPECT/g" /etc/nomad.d/server.hcl \
&& sed -i "s/REGION_NAME/$NOMAD_REGION/g" /etc/nomad.d/server.hcl

mkdir --parents /var/tls \
&& chmod 700 /var/tls \
&& cp cfssl.json /var/tls/cfssl.json \
&& cp tls.hcl /var/tls/tls.hcl

echo "Configuring mTLS"

cfssl print-defaults csr | cfssl gencert -initca - | cfssljson -bare /var/tls/nomad-ca

echo '{}' | cfssl gencert -ca=/var/tls/nomad-ca.pem -ca-key=/var/tls/nomad-ca-key.pem -config=/var/tls/cfssl.json \
    -hostname="server.${NOMAD_REGION}.nomad,localhost,127.0.0.1" - | cfssljson -bare /var/tls/server

echo '{}' | cfssl gencert -ca=/var/tls/nomad-ca.pem -ca-key=/var/tls/nomad-ca-key.pem -config=/var/tls/cfssl.json \
    -hostname="client.${NOMAD_REGION}.nomad,localhost,127.0.0.1" - | cfssljson -bare /var/tls/client

echo '{}' | cfssl gencert -ca=/var/tls/nomad-ca.pem -ca-key=/var/tls/nomad-ca-key.pem -profile=client \
    - | cfssljson -bare /var/tls/cli

cat  /var/tls/tls.hcl >> /etc/nomad.d/nomad.hcl

echo "**** CERTIFICATE AUTHORITY: ****"
less /var/tls/nomad-ca.pem

echo "**** CLIENT CERTIFICATE: ****"
less /var/tls/client.pem

echo "**** CLIENT KEY: ****"
less /var/tls/client-key.pem

echo "**** CLI CERTIFICATE: ****"
less /var/tls/cli.pem

echo "**** CLI KEY: ****"
less /var/tls/cli-key.pem

cp nomad.service /etc/systemd/system/nomad.service \
&& systemctl enable nomad \
&& systemctl start nomad \
&& systemctl status nomad

echo "Configuring ACL"

until nomad acl bootstrap -ca-cert=/var/tls/nomad-ca.pem -client-cert=/var/tls/cli.pem -client-key=/var/tls/cli-key.pem -address=https://127.0.0.1:4646
do
    echo "Can't configure ACL yet, waiting..."
    sleep 1
done

# Cleanup
rm bootstrap.sh bootstrap-internetconnected.sh nomad.service nomad.zip cfssl.json server.hcl tls.hcl

echo "Done"