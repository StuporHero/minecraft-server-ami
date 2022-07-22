#!/usr/bin/env bash

source ./config/config

HUGE_PAGE_SIZE=$(grep Hugepagesize /proc/meminfo | awk '{print $2}')
HUGE_PAGE_UNIT=$(grep Hugepagesize /proc/meminfo | awk '{print $3}')

if [[ ${HUGE_PAGE_UNIT,,} = 'kb' ]]
then
    HUGE_PAGE_SIZE_MB=$((HUGE_PAGE_SIZE / 1024))
elif [[ ${HUGE_PAGE_UNIT,,} = 'mb' ]]
then
    HUGE_PAGE_SIZE_MB=$HUGE_PAGE_SIZE
fi

PAGES_TO_ALLOCATE=$(((TOTAL_MEMORY_SIZE - 1024) / $HUGE_PAGE_SIZE))

echo $PAGES_TO_ALLOCATE > /proc/sys/vm/nr_hugepages
