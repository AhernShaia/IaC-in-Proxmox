terraform {
  required_version = ">= 0.14" 
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.3"
    }
  }
  
}

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


provider "proxmox" {
  pm_api_url   = var.proxmox_api_url
  pm_api_token_id      = var.proxmox_token_id
  pm_api_token_secret = var.proxmox_token_secret
  pm_tls_insecure = true # 設定為true允許使用自簽證書的Proxmox伺服器
}

