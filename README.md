## Build Your Arch Linux System From Scratch 


![](https://github.com/sayems/Arch-Linux/blob/master/screenshot/arch.jpg)


Arch Linux is a do-it-yourself Linux distro, It’s very popular among linux geeks and developers that like to really get at the nuts and bolts of a system. Arch give you the freedom to make any choice about the system. **It does not come with any pre-installed packages/drivers or graphical installer**, instead It uses a **command line installer**.
When you boot it up for the first time, you’ll be greeted with a command-line tool. It expects you to perform the entire installation from the command-line and install all the necessary program/driver by yourself and customize it the way you want it — by piecing together the components that you’d like to include on your system. 

Arch Linux is a really good way to learn what's going on inside a Linux box. You can learn a lot just from the installation process. I am going to walk through the base install, as well as several common post-install things like setting up networking, sound, mounts, X11 and video drivers, and adding users. I am not going to go in great detail on each step, so if you don't know how to do a certain step you may need to seek references elsewhere. 

I'll also show you some tips, tricks and tweaks on how you can change the way the GNOME desktop looks and feel to suit your own personal tastes, that is, take a plain-vanilla GNOME Shell and transform it into a desktop that you like. 

**WARNING**: There is a very **HIGH** chance you can destroy other operating systems or partition, if you don't do it right. **Please proceed with caution**. If you are new to Linux world I HIGHLY suggest you start off with a distro like Ubuntu or Mint Linux. Ubuntu is designed for people who want an off-the-shelf type system, where all of the choices are already made and the users are expected to sacrifice control for convenience.  


Here's a screenshot of my desktop, built just the way I want it

![Here's a screenshot of my current Arch Linux system](https://github.com/sayems/Arch-Linux/blob/master/screenshot/vanila-desktop.png)


![](https://github.com/sayems/Arch-Linux/blob/master/screenshot/desktop-preview.png)

## Prepare the hard drives

Run this command:
```bash
root@arch ~ # cfdisk /dev/sda
```

- sda5 - swap **2GB**
- sda6 - root **18GB** (bootable)

![](https://github.com/sayems/Arch-Linux/blob/master/screenshot/partition.png)

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


##### Setup network, power manager, printer, DNS-SD framework, message bus system
```
$ sudo pacman -Sy networkmanager-dispatcher-ntpd cronie networkmanager network-manager-applet acpid cups avahi dbus udisks2
```

```
$ systemctl enable NetworkManager
$ systemctl enable cronie
$ systemctl enable ntpd
$ systemctl enable acpid
$ systemctl enable avahi-daemon
```

#### Alsa install

```bash
$ sudo pacman -S alsa-utils alsa-plugins alsa-lib pulseaudio-alsa
$ sudo pacman -S pavucontrol pulseaudio
```

#### Open sound manager
```
$ alsamixer
```

#### Toggle mute
```
$ amixer -q set Master toggle
```
#### Volume Down
```
$ amixer -q set PCM 2- unmute
```
#### Volume Up
```
amixer -q set PCM 2+ unmut
```

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

![](https://github.com/sayems/Arch-Linux/blob/master/screenshot/nvidia-search.png)

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


## Enable multilib repository
```
# nano /etc/pacman.conf
```
Scroll down and un-comment the ‘multilib’ repo:
```
[multilib]
Include = /etc/pacman.d/mirrorlist
```

```
# pacman -Sy
```


## Install Software

```
# pacman -S firefox, terminator, vlc, skype, synergy, sublime-text
```


### Reboot System
```
# reboot
```


### Yaourt

```
$ sudo gedit /etc/pacman.conf
```

Add Yaourt repository:

```
[archlinuxfr]
SigLevel = Never
Server = http://repo.archlinux.fr/$arch
```
run:
```
$ pacman -Sy yaourt
```


Install AUR Packages

```
$ yaourt -S ttf-ms-fonts
$ yaourt -S fontconfig-ubuntu
$ yaourt -S freetype2-ubuntu
$ yaourt -S ttf-noto
$ yaourt -S ttf-mac-fonts
$ yaourt -S ttf-tahoma
$ yaourt -S jdk
$ yaourt -S intellij-idea-ultimate-edition
$ yaourt -S ubuntu-themes
$ yaourt -S spotify
$ yaourt -S yaourt moka-icon-theme-git
$ yaourt -S gnome-session-properties
```

--

### Setup Albert 

#### Create a albert folder 
```
$ mkdir -p ~/temp/albert && cd ~/temp/albert
```

#### Download sources
```bash
$ wget https://raw.githubusercontent.com/ManuelSchneid3r/albert/master/packaging/linux/arch/PKGBUILD
```

#### Automatically resolve dependencies with pacman
```bash
$ makepkg -s
```

#### install 
```bash
$ sudo pacman -U albert-*.pkg.tar.xz
```

#### Create a autostart program

```bash
$ cd
$ cp /usr/share/applications/albert.desktop .config/autostart/
```

Make sure you have gnome-session-properties installed

```
Press & hold    : Alt+F2
Enter a command : gnome-session-properties
Click on "Close" Button
```

![](https://github.com/sayems/Arch-Linux/blob/master/screenshot/add-albert-autostart.png)

```
Name    : Albert
Command : albert
Comment : A quick launcher for Linux
Click on "Add" Button
```
--

### Beautify Grub 2 Boot Loader by Installing Themes

By default, Arch Linux boot loader grub doesn’t use any theme. You can customize theme. Here’s a simple guide installing Grub2 themes (background, logos, fonts, scroll bar, etc).

**Download Archlinux theme from AUR:**  
Archxion: [grub2-theme-archxion](https://aur.archlinux.org/packages.php?ID=59370)  
Archlinux: [grub2-theme-archlinux](https://aur.archlinux.org/packages.php?ID=59643)

```
$ yaourt -S grub2-theme-archxion
$ yaourt -S grub2-theme-archlinux
```

**Edit your /etc/default/grub and change line:**  

```
$ sudo subl /etc/default/grub
```
<code>\#GRUB_THEME="/path/to/gfxtheme"  
to  
GRUB_THEME="/boot/grub/themes/Archxion/theme.txt"  
or  
GRUB_THEME="/boot/grub/themes/Archlinux/theme.txt"</code>

**The resolution the theme was designed to show best at 1024x768:**  
<code>GRUB_GFXMODE=auto  
to  
GRUB_GFXMODE=1024x768</code>  

**Update grub configuration:**  
<code>\# grub-mkconfig -o /boot/grub/grub.cfg</code>

--


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

--

### Arch Linux Pacman 

In Arch Linux softwares can be installed easily from the terminal by using pacman and you also use pacman to uninstall them( if you want to install softwares from the AUR, you can use packer). However, most linux softwares always come with many dependencies so if you just use the command pacman -R packagename to remove the application, there will always be a lot of orphan packages left around. The proper command to remove a linux software in Arch Linux should be:

```
 sudo pacman -Rns packagename 
``` 

This command will remove the package and its dependencies and all the settings of the application.

If you dont already know this tip, chances that there are still many orphan packages in your Arch linux box. To check if you have any orphan package, use the following command:

```
 sudo pacman -Qdt
```  

This command will display a list of orphan packages. To remove these packages, you can use the following command:

```
sudo pacman -Rns $(pacman -Qdtq) 
```

After that, all the orphan dependencies will be wiped out.

Note: In Arch Linux softwares will be updated very frequently so to keep your system clean, you should also use the command sudo pacman -Scc to clean cache and outdated packages. (But only do so after you make sure the new packages are working nicely. If they are not, you still need the old packages to downgrade)

















































