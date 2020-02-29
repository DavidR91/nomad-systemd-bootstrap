log_level = "DEBUG"
data_dir = "/opt/nomad"

client {
  enabled = true
  servers = ["SERVER_ADDRESS"]
}

tls {
  http = true
  rpc  = true

  ca_file   = "/var/tls/ca-key.pem"
  cert_file = "/var/tls/client.pem"
  key_file  = "/var/tls/client-key.pem"
  
  verify_server_hostname = true
  verify_https_client    = true
}

ports {
  http = 4648
  rpc  = 4649
  serf = 4650
}

acl {
  enabled = true
}