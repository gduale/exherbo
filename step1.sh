#!/bin/bash
##Setup Exherbo

dd='/dev/sda'
#Eraze disk
dd if=/dev/zero of=$dd bs=512 count=1

#Make partitions
echo -e "n\n\n\n\n+500M\nw\n" | fdisk $dd #/boot
echo -e "n\n\n\n\n+5G\nw\n" | fdisk $dd #/
echo -e "n\n\n\n\n\nw\n" | fdisk $dd #/home

mkfs.ext2 /dev/sda1 #/boot 
mkfs.ext4 /dev/sda2 #/
mkfs.ext4 /dev/sda3 #/home

mkdir /mnt/exherbo && mount /dev/sda2 /mnt/exherbo && cd /mnt/exherbo
#curl -O http://dev.exherbo.org/stages/exherbo-x86_64-pc-linux-gnu-current.tar.xz
curl -O http://127.0.0.1/~gui/exherbo-x86_64-pc-linux-gnu-current.tar.xz
#curl -O http://dev.exherbo.org/stages/sha1sum
curl -O http://27.0.0.1/~gui/sha1sum
grep exherbo-x86_64-pc-linux-gnu-current.tar.xz sha1sum | sha1sum -c
if [ $? -ne 0 ];then
  echo "sha1sum ERROR"
  exit 1
fi

tar xJpf exherbo*xz

echo "/dev/sda2    /               ext4      defaults    0 0" > etc/fstab
echo "/dev/sda3    /home           ext4      defaults    0 2" >> etc/fstab
echo "/dev/sda1    /boot           ext2      defaults    0 0" >> etc/fstab

#Chroot into the system
mount -o rbind /dev /mnt/exherbo/dev/
mount -o bind /sys /mnt/exherbo/sys/
mount -t proc none /mnt/exherbo/proc/
mount /dev/sda1 /mnt/exherbo/boot/
mount /dev/sda3 /mnt/exherbo/home/
cp /etc/resolv.conf /mnt/exherbo/etc/resolv.conf
cp /root/exherbo/step2_chroot.sh /mnt/exherbo/
cp /root/exherbo/kernel.config /mnt/exherbo/
env -i TERM=$TERM SHELL=/bin/bash HOME=$HOME $(which chroot) /mnt/exherbo /step2_chroot.sh
