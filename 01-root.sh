#!/bin/bash -xe

# Install jq
yum install -y jq

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
chown minecraft:minecraft /tmp/eula.txt /tmp/config /tmp/server.properties

# Create the systemd service for minecraft
chown root:root /tmp/minecraft.service
mv /tmp/minecraft.service /etc/systemd/system/minecraft.service
systemctl daemon-reload
systemctl enable minecraft
