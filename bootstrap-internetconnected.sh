export NOMAD_DATACENTER=eu-west-2
export NOMAD_REGION=europe
export NOMAD_ADDR=localhost:4647

apt-get update && apt-get install -y wget unzip
wget https://releases.hashicorp.com/nomad/0.10.4/nomad_0.10.4_linux_amd64.zip -O nomad.zip
chmod +x ./bootstrap.sh
./bootstrap.sh