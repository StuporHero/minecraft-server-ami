#!/bin/bash -xe
download_url=$1

curl -s "https://get.sdkman.io" | bash
source /etc/minecraft/.sdkman/bin/sdkman-init.sh
sdk install java 22.1.0.r17-grl
wget $download_url
mv  /tmp/eula.txt ./