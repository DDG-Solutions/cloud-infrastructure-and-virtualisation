resource "tls_private_key" "vm_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_sensitive_file" "private_key" {
  content  = tls_private_key.vm_ssh_key.private_key_openssh
  filename = "${path.module}/id_rsa_ca2"
}

resource "local_sensitive_file" "public_key" {
  content  = tls_private_key.vm_ssh_key.public_key_openssh
  filename = "${path.module}/id_rsa_ca2.pub"
}
