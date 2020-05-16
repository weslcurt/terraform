resource "proxmox_vm_qemu" "k3s_server" { 
  count             = 1
  name              = "kubernetes-master-${count.index}"
  target_node       = "<node>"

  clone             = "centos-7-cloudinit-template"

  os_type           = "cloud-init"
  cores             = 1
  sockets           = "1"
  cpu               = "host"
  memory            = 1024
  scsihw            = "virtio-scsi-pci"
  bootdisk          = "scsi0"

  disk {
    id              = 0
    size            = 20
    type            = "virtio"
    storage         = "local"
    iothread        = true
  }

  network {
    id              = 0
    model           = "virtio"
    bridge          = "vmbr0"
  }

  lifecycle {
    ignore_changes  = [
      network,
    ]
  }

  # Cloud Init Settings
  ipconfig0         = "ip=<IP>${count.index + 1}/24,gw=192.168.2.1"
  ciuser = "<user>"
 # cipassword = "<password>"
 # sshkeys = <<EOF
 # ${var.ssh_key}
 # EOF
}
