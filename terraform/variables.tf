variable "ssh_public_key_path" {
  description = "Path to the SSH public key file to apply to the VM"
  type        = string
  default     = "~/.ssh/id_rsa_dstuartkelly.pub"
}
