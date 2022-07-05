#!/bin/bash -xe
useradd -m -d /etc/minecraft -s /bin/bash minecraft
mkdir /var/minecraft; chown minecraft:minecraft /var/minecraft
chown minecraft:minecraft /tmp/eula.txt

chown root:root /tmp/minecraft.service
mv /tmp/minecraft.service /etc/systemd/system/minecraft.service
systemctl daemon-reload
systemctl enable minecraft
