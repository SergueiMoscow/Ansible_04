resource "yandex_compute_instance" "log_web" {
  for_each = { for vm in local.vms : vm.vm_name => vm }

  name = each.value.vm_name
  hostname = each.value.vm_name
  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }
  resources {
    cores = each.value.cpu
    memory = each.value.ram
    core_fraction = each.value.core_fraction
  }

  boot_disk {
    initialize_params {
        image_id = each.value.image_id
    }
  }

  scheduling_policy {
    preemptible = var.preemptible
  }

  metadata = local.vm_metadata

}


resource "local_file" "hosts_templatefile" {
  content = templatefile("${path.module}/hosts.tftpl",
    {
      clickhouse_ip = yandex_compute_instance.log_web["clickhouse"].network_interface[0].nat_ip_address,
      vector_ip  = yandex_compute_instance.log_web["vector"].network_interface[0].nat_ip_address,
      lighthouse_ip   = yandex_compute_instance.log_web["lighthouse"].network_interface[0].nat_ip_address
      username = var.vms_ssh_user
    }
  )

  filename = local.hosts_filename
}


locals {
  vms = [
    {
      vm_name       = "clickhouse"
      cpu           = 2
      ram           = 4
      core_fraction = 20
      disk_volume   = 20
      image_id      = "fd859s00ru90mn31cjf4" # ubuntu
    },
    {
      vm_name       = "vector"
      cpu           = 2
      ram           = 4
      core_fraction = 20
      disk_volume   = 5
      image_id      = "fd8avksksdmbc77l1s7t" # almalinux
    },
    {
      vm_name       = "lighthouse"
      cpu           = 2
      ram           = 4
      core_fraction = 20
      disk_volume   = 5
      image_id      = "fd8avksksdmbc77l1s7t" # almalinux
    }
  ]

  hosts_filename = "${abspath(path.module)}/../playbook/inventory/prod.yml"

  vm_metadata = {
    user-data = "${file("${abspath(path.module)}/cloud-init.yml")}"
  }
  # vm_metadata = {
  #   serial-port-enable = 1
  #   ssh-keys           = "${var.vms_ssh_user}:${file("~/.ssh/id_ed25519.pub")}"
  # }
}

