# 1. Resource Group Module
module "resource_group" {
  source  = "../module/resource group"
  rgnames = var.rgnames
}

# 2. Virtual Network Module
module "vnet" {
  source     = "../module/vnet"
  vnetname   = var.vnetname
  depends_on = [module.resource_group]
}

# 3. Subnet Module
module "subnet" {
  source     = "../module/subnet"
  subnetname = var.subnetname
  depends_on = [module.vnet]
}

# 4. Public IP Module
module "public_ip" {
  source     = "../module/public ip"
  pipname    = var.pipname
  depends_on = [module.resource_group]
}

# 5. Network Security Group Module
module "nsg" {
  source     = "../module/NSG"
  nsgname    = var.nsgname
  depends_on = [module.resource_group]
}

# 6. Network Interface Module (Subnet, Public IP aur NSG teeno se attach hota hai)
module "nic" {
  source     = "../module/nic"
  nicname    = var.nicname
  depends_on = [module.subnet, module.public_ip, module.nsg]
}

# 7. Key Vault Module
module "keyvault" {
  source     = "../module/keyvault"
  keyvaults  = var.keyvaults
  depends_on = [module.resource_group]
}

# 8. Virtual Machine Module
module "virtual_machine" {
  source     = "../module/virtual machine"
  vms        = var.vms
  depends_on = [module.nic, module.keyvault]
}

# 9. Azure Bastion Module
module "bastion" {
  source     = "../module/bastion"
  bastions   = var.bastions
  depends_on = [module.subnet, module.public_ip]
}