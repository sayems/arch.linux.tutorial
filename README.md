## Prepare the hard drives

Run this command:
```bash
root@arch ~ # cfdisk /dev/sda
```

- sda5 - swap **2GB**
- sda6 - root **18GB** (bootable)

```bash
root@arch ~ # mkfs.ext4  /dev/sda6
root@arch ~ # mount /dev/sda6 /mnt
```

```bash
root@arch ~ # mkswap /dev/sda5
root@arch ~ # swapon /dev/sda5
```

## Installing System Base


```bash
root@arch ~ # pacstrap /mnt base base-devel
```

## Configuration the Installation

```bash
root@arch ~ # arch-chroot /mnt
```

```bash
sh-4.3# ip link
sh-4.3#  systemctl enable dhcpcd@enp3s0.service
```

```bash
sh-4.3# nano /etc/locale.gen
sh-4.3# locale-gen
sh-4.3# echo LANG=en_US.UTF-8 > /etc/locale.conf
sh-4.3# export LANG=en_US.UTF-8
```

```
# ln -s /usr/share/zoneinfo/America/New_York /etc/localtime
# hwclock --systohc --localtime
```

```
# echo USER_NAME > /etc/hostname
```

```bash
sh-4.3# passwd  
```

```bash
sh-4.3# pacman -S grub os-prober
sh-4.3# grub-install /dev/sda
sh-4.3# mkinitcpio -p linux
sh-4.3# grub-mkconfig -o /boot/grub/grub.cfg
```

## Exit
```
sh-4.3# exit out 
```

```bash
root@arch ~ # genfstab /mnt >> /mnt/etc/fstab
```

```bash
root@arch ~ # umount /mnt
```

## Reboot the system

```bash
root@arch ~ #  reboot
```




















































