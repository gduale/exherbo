#!/bin/bash

env -i TERM=$TERM SHELL=/bin/bash HOME=$HOME $(which chroot) /mnt/exherbo /bin/bash
source /etc/profile
export PS1="(chroot) $PS1"

echo "étape : cave sync...(todo)"
cave sync

#Kernel
KERNEL=linux-5.5
#wget https://cdn.kernel.org/pub/linux/kernel/v5.x/${KERNEL}.tar.xz
wget http://192.168.0.27/~gui/${KERNEL}.tar.xz
tar xJf ${KERNEL}*
cd $KERNEL
#make nconfig
#cp /kernel.config /linux-5.3.12/.config
make menuconfig
make -j 4
make modules_install
cp arch/x86/boot/bzImage /boot/kernel

#Systemd
echo "*/* systemd" >> /etc/paludis/options.conf
cave resolve -x sys-apps/Systemd
cave resolve world -cx
eclectic init list
echo "exherbo" > /etc/hostname
cave sync
cave resolve world -c
cave resolve --execute --preserve-world --skip-phase test sys-apps/systemd

#Grub
grub-install /dev/sda
cat<<EOF > /boot/grub/grub.cfg
set timeout=10
set default=0
menuentry "Exherbo" {
    set root=(hd0,1)
    linux /kernel root=/dev/sda2
}
EOF

#Hostname
cat<<EOF > /etc/hosts
127.0.0.1    my-hostname.domain.foo    my-hostname    localhost
::1          localhost
EOF

#Password
echo "Set the root password:"
echo -e "root\nroot"|passwd

#Locale
localedef -i fr_FR -f UTF-8 fr_FR
echo LANG="fr_FR.UTF-8" > /etc/env.d/99locale
ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime
 
echo "All is done! You can reboot."
