variable "version" {
  type = string
}

variable "download_url" {
  type = string
}

packer {
  required_plugins {
    amazon = {
      version = "1.0.8"
      source = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "minecraft-server-ami" {
  ami_name = "minecraft-${var.version}-{{timestamp}}"
  ssh_username = "ec2-user"
  spot_instance_types = [
    "t3.micro",
    "t3a.micro",
    "t3.small",
    "t3a.small"
  ]
  spot_price = "0.019"
  source_ami_filter {
    filters = {
      architecture = "x86_64"
      virtualization-type = "hvm"
      name = "amzn2-ami-kernel-5.10-hvm-2.0.*"
    }
    owners = ["137112412989"]
    most_recent = true
  }
  launch_block_device_mappings {
    device_name = "/dev/sdf"
    volume_type = "gp2"
    volume_size = 4
    delete_on_termination = true
  }
}

build {
  sources = [
    "source.amazon-ebs.minecraft-server-ami"
  ]

  provisioner "file" {
    source = "files/config"
    destination = "/tmp/config"
  }

  provisioner "file" {
    source = "files/eula.txt"
    destination = "/tmp/eula.txt"
  }

  provisioner "file" {
    source = "files/minecraft.service"
    destination = "/tmp/minecraft.service"
  }

  provisioner "file" {
    source = "files/minecraft.sh"
    destination = "/tmp/minecraft.sh"
  }

  provisioner "file" {
    source = "files/server.properties"
    destination = "/tmp/server.properties"
  }

  provisioner "shell" {
    script = "01-root.sh"
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo {{ .Path }}"
  }

  provisioner "shell" {
    script = "02-minecraft.sh"
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -iu minecraft {{ .Path }} ${var.download_url}"
  }
}
