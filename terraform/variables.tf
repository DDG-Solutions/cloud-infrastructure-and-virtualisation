variable "ssh_public_key_path" {
  description = "Path to the SSH public key file to apply to the VM"
  type        = string
  default     = "~/.ssh/id_rsa_dstuartkelly.pub"
}

variable "location" {
  description = "Azure region to deploy resources"
  type        = string
  default     = "francecentral"
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_B2ats_v2"
}
