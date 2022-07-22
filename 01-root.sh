#!/bin/bash -xe

# Install prerequisites
yum install -y jq amazon-efs-utils
python3 -m pip install botocore

# Configure swap
lsblk
blk_dev=$(lsblk -J | jq -r '.blockdevices[] | select(.mountpoint == null) | select(has("children") | not) | .name')
mkswap --label SWAP /dev/$blk_dev
echo "LABEL=SWAP swap swap defaults 0 0" >> /etc/fstab
swapon -a

# Create user minecraft and configure the filesystem
useradd -m -s /bin/bash minecraft
mkdir /var/minecraft /var/log/minecraft /opt/minecraft /etc/minecraft
chown minecraft:minecraft /var/minecraft /var/log/minecraft /opt/minecraft /etc/minecraft
chown minecraft:minecraft /tmp/eula.txt /tmp/config /tmp/server.properties /tmp/minecraft.sh

# Prepare the hugepages script (runs before minecraft)
chown root:root /tmp/hugepages.sh
chmod 774 /tmp/hugepages.sh
mv /tmp/hugepages.sh /opt/minecraft/

# Create the systemd service for minecraft
chown root:root /tmp/minecraft.service
mv /tmp/minecraft.service /etc/systemd/system/minecraft.service
systemctl daemon-reload
systemctl enable minecraft

# Clean cloud-init
cloud-init clean
