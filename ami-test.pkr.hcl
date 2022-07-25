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
  pause_before_connecting = "2m"
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

  provisioner "shell-local" {
    inline = [
      "ssh=$(mktemp -d)",
      "echo '${build.SSHPrivateKey}' > $ssh/id_rsa",
      "pytest --ssh-identity-file=$ssh/id_rsa --hosts=${build.User}@${build.Host} test/test_image.py",
      "rm -rf $ssh"
    ]
  }
}
