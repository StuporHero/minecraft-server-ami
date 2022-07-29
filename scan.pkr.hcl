variable "ami" {
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
  ami_name = "doesn't matter"
  skip_create_ami = true
  ssh_username = "ec2-user"
  ssh_interface = "public_ip"
  spot_instance_types = [
    "r6i.large",
    "r5n.large",
    "r6a.large",
    "r6id.large",
    "r5ad.large",
    "r5b.large",
    "r5dn.large",
    "r5d.large",
    "r5.large",
    "r5a.large",
    "r4.large"
  ]
  spot_price = "0.04"
  source_ami = "${var.ami}"
}

build {
  sources = [
    "source.amazon-ebs.minecraft-server-ami"
  ]

  provisioner "shell" {
    inline = [
      "curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sudo sh -s -- -b /usr/local/bin v0.30.4",
      "sudo /usr/local/bin/trivy rootfs --format cyclonedx --no-progress --output sbom.json --security-checks vuln /",
      "sudo /usr/local/bin/trivy rootfs --format table  --ignore-unfixed --no-progress --output vulnerabilities.txt --security-checks vuln /"
    ]
  }

  provisioner "file" {
    source = "sbom.json"
    destination = "sbom.json"
    direction = "download"
  }

  provisioner "file" {
    source = "vulnerabilities.txt"
    destination = "vulnerabilities.txt"
    direction = "download"
  }
}
