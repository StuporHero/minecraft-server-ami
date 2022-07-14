#!/usr/bin/env bash

source ./config/config
source $HOME/.sdkman/bin/sdkman-init.sh

java -Xmx2048M -Xms1024M -jar server.jar --nogui --universe $MINECRAFT_UNIVERSE --world $MINECRAFT_WORLD
