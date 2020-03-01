tls {
  http = true
  rpc  = true
  
  ca_file   = "/var/tls/nomad-ca.pem"
  cert_file = "/var/tls/server.pem"
  key_file  = "/var/tls/server-key.pem"
  
  verify_server_hostname = true
  verify_https_client    = false
}