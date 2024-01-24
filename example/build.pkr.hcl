# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

packer {
  required_version = ">= 1.0.8"
  required_plugins {
    vmware = {
      version = ">= 1.0.7"
      source  = "github.com/hashicorp/vmware"
    }
    vagrant = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/vagrant"
    }
  }
}

build {
  sources = ["source.vmware-iso.debian"]
  provisioner "shell"{
    inline=[
      "mkdir ~/.ssh",
      "touch ~/.ssh/authorized_keys",
      "chmod 600 ~/.ssh/authorized_keys",
      "chmod 700 ~/.ssh",
      "echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDvfvKlZn9y1o6Nw/cSTKI+NNzWB1jHVgR2nAVWD+d2w admin@admins-MacBook-Pro.local' >> ~/.ssh/authorized_keys",
      "echo 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key'>> ~/.ssh/authorized_keys",
      "echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN1YdxBpNlzxDqfJyw/QKow1F+wvG9hXGoqiysfJOn5Y vagrant insecure public key'>> ~/.ssh/authorized_keys",
      "echo 'vagrant ALL=(ALL) NOPASSWD: ALL > /target/etc/sudoers.d/vagrant && chmod 0440 /target/etc/sudoers.d/vagrant'",
      "echo 'deb http://deb.debian.org/debian bookworm main non-free-firmware' | sudo tee -a /etc/apt/sources.list",
      "echo 'deb-src http://deb.debian.org/debian bookworm main non-free-firmware' | sudo tee -a /etc/apt/sources.list",
      "echo 'deb http://deb.debian.org/debian-security/ bookworm-security main non-free-firmware' | sudo tee -a /etc/apt/sources.list",
      "echo 'deb-src http://deb.debian.org/debian-security/ bookworm-security main non-free-firmware' | sudo tee -a /etc/apt/sources.list",
      "echo 'deb http://deb.debian.org/debian bookworm-updates main non-free-firmware' | sudo tee -a /etc/apt/sources.list",
      "echo 'deb-src http://deb.debian.org/debian bookworm-updates main non-free-firmware' | sudo tee -a /etc/apt/sources.list",
      "sudo apt-get update -y",
      "sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y",
      "sudo DEBIAN_FRONTEND=noninteractive apt-get install open-vm-tools -y",
    ]
  }
  post-processors {
    post-processor "vagrant" {
      keep_input_artifact = true
      output = "builds/debian-vmware.box"
      // provider_override = "vmware"
    }
    post-processor "vagrant-cloud" {
      access_token = "${var.cloud_token}"
      box_tag      = "meherlippmann/squeezebox"
      version      = "1.0.3"
      architecture = "arm64"
    }
  }

}
