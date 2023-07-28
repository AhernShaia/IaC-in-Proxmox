`情境：使用 Terrform快速建立VM `
## 1. 建立 API Token
`datacenter` --> `Permissions` --> `API Tokens` ->`Add`  
![](https://hackmd.io/_uploads/r1gP7hgon.png)
![](https://hackmd.io/_uploads/r1QFm3gih.png)

## 2. 撰寫 terraform
[Proxmox Provider參數查閱](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs)

`main.tf` - 主要執行文件，盡量避免敏感資訊。
```hcl=
terraform {
  required_version = ">= 0.14" 
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.3"
    }
  }
}
<!-- 聲明變數 -->
variable "proxmox_api_url" {
  type = string
}
variable "proxmox_token_id" {
  type = string
  sensitive = true
}
variable "proxmox_token_secret" {
  type = string
  sensitive = true
}

<!-- 連線資訊 -->
provider "proxmox" {
  pm_api_url   = var.proxmox_api_url
  pm_api_token_id      = var.proxmox_token_id
  pm_api_token_secret = var.proxmox_token_secret
  pm_tls_insecure = true # 設定為true允許使用自簽證書的Proxmox伺服器
}

```
初始化
```bash=
terraform init
```
`credentials.auto.tfvars` - 變數文件，將變數值隔離給外部調用。

```haskell=
proxmox_api_url = "https://domain/api2/json"
proxmox_token_id = "User@pam!Token ID"
proxmox_token_secret = "Secret"
```
建立VM
`srv-vm.tf` - 建立VM的描述檔
```haskell=

resource "proxmox_vm_qemu" "AIO_vm" {
  name        = "master"
  desc = "Ubuntu Server"
  target_node = "pve3"
  memory      = 8196
  cores       = "2"
  sockets     = "1"
  onboot = true
  
  iso         = "local:iso/ubuntu-22.04.2-live-server-amd64.iso"

  disk {
    type = "scsi"
    storage     = "local-lvm"
    size        = "10G"
  }
  
  network {
    model       = "virtio"
    bridge      = "vmbr0" #
  }
    os_type     = "ubuntu"
}
```
---
2. 測試/查看修改
```bash=
# 可以查看變化,所有參數和測試文件是否有錯誤
terraform plan
```

2. 執行
```
terraform apply -auto-approve
```