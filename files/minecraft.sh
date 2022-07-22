#!/usr/bin/env bash

source ./config/config
source $HOME/.sdkman/bin/sdkman-init.sh

MINECRAFT_WORLD=${MINECRAFT_WORLD:-default}

exec java -XX:+UseLargePages -XX:+UseZGC -XX:+AlwaysPreTouch -Xms$HEAP_SIZE -Xmx$HEAP_SIZE -jar server.jar --nogui --universe /var/minecraft/universe --world $MINECRAFT_WORLD
