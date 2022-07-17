#!/usr/bin/env bash

source ./config/config
source $HOME/.sdkman/bin/sdkman-init.sh
JDK_JAVA_OPTIONS=${JDK_JAVA_OPTIONS:-'-Xms1024M -Xmx2048M'}

java -jar server.jar --nogui --universe $MINECRAFT_UNIVERSE --world $MINECRAFT_WORLD
