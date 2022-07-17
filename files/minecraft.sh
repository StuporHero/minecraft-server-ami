#!/usr/bin/env bash

source ./config/config
source $HOME/.sdkman/bin/sdkman-init.sh

MINECRAFT_WORLD=${MINECRAFT_WORLD:-default}
JDK_JAVA_OPTIONS=${JDK_JAVA_OPTIONS:-'-Xms1024M -Xmx2048M'}

java -jar server.jar --nogui --universe /var/minecraft/universe --world $MINECRAFT_WORLD
