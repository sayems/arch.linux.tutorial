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

--

## Setup the system

##### Create new user

```
# useradd -m -g users -G wheel,storage,power,lp,network,audio,video,optical -s /bin/bash sayem
# passwd sayem
```

```
# EDITOR=nano visudo
```
Uncomment this line in this file:
```
%wheel ALL=(ALL) ALL
```

```
# pacman -S xorg-server xorg-xinit xorg-utils xorg-server-utils mesa
```
Select Option #2  Nvidia 340xx package

```
# pacman -S xorg-twm xterm xorg-xclock
```

Search for Nvidia driver
```
# pacman –Ss | grep nvidia
```
Install Nvidia
```
# pacman -S nvidia-340xx
# nvidia-xconfig
```

Install Cinnamon Desktop Enviroment
```
# sudo pacman -S cinnamon nemo-fileroller
# sudo pacman –S gdm
# sudo systemctl enable gdm
```



#### OR

Install GNOME Desktop Environment

```
# sudo pacman -S gnome gnome-extra
# sudo systemctl enable gdm
```

### Reboot System
```
# reboot
```



## How to skip all Yaourt prompts on Arch Linux

[Yaourt](https://wiki.archlinux.org/index.php/yaourt) is probably the best tool to automatically download and install packages from the [Arch User Repository](https://aur.archlinux.org/), also known as AUR. It’s really powerful; however, by default, it prompts you a **LOT** for confirmations of different things, such as checking if you want to install something, if you want to edit the `PKGBUILD`, etc. As a result, Yaourt is pretty annoying if you’re used to the hands-free nature of most other package managers.

As it turns out, there is a file you can create called `~/.yaourtrc` that can change the behavior of Yaourt.

To turn off all of the prompts, type the following into a new file called `~/.yaourtrc`:

```
NOCONFIRM=1
BUILD_NOCONFIRM=1
EDITFILES=0
```

The first line will skip the messages confirming if you really want to install the package.

The second line will skip the messages asking you if you want to continue the build.

The third and last line will skip the messages asking if you want to edit the `PKGBUILD` files.

When you’re done doing this, Yaourt should now stop being a pain to use. Have fun with your hands-free installs!



















































