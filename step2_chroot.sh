#!/bin/bash

env -i TERM=$TERM SHELL=/bin/bash HOME=$HOME $(which chroot) /mnt/exherbo /bin/bash
source /etc/profile
export PS1="(chroot) $PS1"

echo "étape : cave sync...(todo)"
cave sync

#Kernel
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.3.11.tar.xz
tar xJf linux-5*
cd linux-5*
pwd

