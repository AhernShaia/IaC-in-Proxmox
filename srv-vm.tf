
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
    bridge      = "vmbr0" # 設定您的Proxmox橋接介面
    
  }

    os_type     = "ubuntu"

}