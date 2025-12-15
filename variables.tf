variable "ssh_public_key" {
  description = "The public SSH key to install for the ubuntu user"
  type        = string
}

variable "vm_username" {
  description = "The username for the VM"
  type        = string
  default     = "perrypenguin"
}

