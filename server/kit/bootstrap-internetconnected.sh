export NOMAD_DATACENTER=eu-west-2
export NOMAD_REGION=europe
export BOOTSTRAP_EXPECT=1

apt-get update && apt-get install -y wget unzip curl

# Nomad
wget -nv https://releases.hashicorp.com/nomad/0.10.4/nomad_0.10.4_linux_amd64.zip -O nomad.zip

# cfssl
wget -nv https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 -O /bin/cfssl 
wget -nv https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 -O /bin/cfssljson

chmod +x ./bootstrap.sh
./bootstrap.sh