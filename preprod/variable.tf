variable "rgnames" {
  description = "Resource groups configuration map"
  type        = map(any)
}

variable "vnetname" {
  description = "Virtual networks configuration map"
  type        = map(any)
}

variable "subnetname" {
  description = "Subnets configuration map"
  type        = map(any)
}

variable "pipname" {
  description = "Public IPs configuration map"
  type        = map(any)
}

variable "nsgname" {
  description = "NSGs configuration map"
  type        = map(any)
}

variable "nicname" {
  description = "NICs configuration map"
  type        = map(any)
}

variable "keyvaults" {
  description = "Key Vaults configuration map"
  type        = map(any)
}

variable "vms" {}

variable "bastions" {
  description = "Bastion Hosts configuration map"
  type        = map(any)
}