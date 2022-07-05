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
  ami_name = "minecraft-server-ami-{{timestamp}}"
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
}

build {
  sources = [
    "source.amazon-ebs.minecraft-server-ami"
  ]

  provisioner "file" {
    source = "eula.txt"
    destination = "/tmp/eula.txt"
  }

  provisioner "file" {
    source = "minecraft.service"
    destination = "/tmp/minecraft.service"
  }

  provisioner "shell" {
    script = "root.sh"
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo {{ .Path }}"
  }

  provisioner "shell" {
    script = "minecraft.sh"
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -iu minecraft {{ .Path }} ${var.download_url}"
  }
}
