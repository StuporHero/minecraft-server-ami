#!/bin/bash -xe
download_url=$1

# Install java
curl -s "https://get.sdkman.io" | bash
echo 'source $HOME/.sdkman/bin/sdkma-init.sh' >> $HOME/.bash_profile
source $HOME/.sdkman/bin/sdkman-init.sh
sdk install java 22.1.0.r17-grl

# Install minecraft
cd /opt/minecraft
wget -O server.jar $download_url
mv  /tmp/eula.txt /tmp/minecraft.sh ./
mv /tmp/config /tmp/server.properties /etc/minecraft/
chmod 774 ./minecraft.sh
ln -s /etc/minecraft config
ln -s /var/log/minecraft logs
ln -s /etc/minecraft/server.properties server.properties
ln -s /var/minecraft/whitelist.json whitelist.json
ln -s /var/minecraft/ops.json ops.json
