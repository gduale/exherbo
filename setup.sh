mkdir /mnt/exherbo && mount /dev/sda2 /mnt/exherbo
mount -o bind /sys /mnt/exherbo/sys/
mount -t proc none /mnt/exherbo/proc/
mount /dev/sda1 /mnt/exherbo/boot/
mount /dev/sda3 /mnt/exherbo/home/
cp /etc/resolv.conf /mnt/exherbo/etc/resolv.conf
env -i TERM=$TERM SHELL=/bin/bash HOME=$HOME $(which chroot) /mnt/exherbo /bin/bash

