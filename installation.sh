#! /bin/sh

mkfs.fat -F 32 /dev/sda1

mkfs.ext4 /dev/sda2

loadkeys uk

timedatectl set-ntp true

mount /dev/sda2 /mnt

pacstrap /mnt base linux linux-firmware

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt

ln -sf /usr/share/zoneinfo/Iran/Tehran /etc/localtime

hwclock --systohc

echo "en_GB.UTF-8 UTF-8" >> /etc/locale.gen

locale-gen

echo "LANG=en_GB.UTF-8" >> /etc/locale.conf

echo "KEYMAP=uk" >> /etc/vconsole.conf

echo "arch" >> /etc/hostname

echo "127.0.0.1 localhost" >> /etc/hosts

echo "::1         localhost" >> /etc/hosts

echo "127.0.1.1 arch.localdomain arch" >> /etc/hosts

mkinitcpio -P

useradd -m rahnamai

passwd rahnamai

usermod -aG wheel,audio,video,storage rahnamai

passwd

pacman -S grub efibootmgr dosfstools os-prober mtools networkmanager

mkdir /boot/EFI

mount /dev/sda1 /boot/EFI

grub-install --target=x86_64-efi --bootloader-id-grub_uefi --recheck

grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager

exit

umount -R /mnt

reboot
