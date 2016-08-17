## Build Your Arch Linux System From Scratch 


![](https://github.com/sayems/Arch-Linux/blob/master/screenshot/arch.jpg)


Arch Linux is a do-it-yourself Linux distro, It’s very popular among linux geeks and developers that like to really get at the nuts and bolts of a system. Arch give you the freedom to make any choice about the system. **It does not come with any pre-installed packages/drivers or graphical installer**, instead It uses a **command line installer**.
When you boot it up for the first time, you’ll be greeted with a command-line tool. It expects you to perform the entire installation from the command-line and install all the necessary program/driver by yourself and customize it the way you want it — by piecing together the components that you’d like to include on your system. 

Arch Linux is a really good way to learn what's going on inside a Linux box. You can learn a lot just from the installation process. I am going to walk through the base install, as well as several common post-install things like setting up networking, sound, mounts, X11 and video drivers, and adding users. I am not going to go in great detail on each step, so if you don't know how to do a certain step you may need to seek references elsewhere. 

I'll also show you some tips, tricks and tweaks on how you can change the way the GNOME desktop looks and feel to suit your own personal tastes, that is, take a plain-vanilla GNOME Shell and transform it into a desktop that you like. 

**WARNING**: There is a very **HIGH** chance you can destroy other operating systems or partition, if you don't do it right. **Please proceed with caution**. If you are new to Linux world I HIGHLY suggest you start off with a distro like Ubuntu or Mint Linux. Ubuntu is designed for people who want an off-the-shelf type system, where all of the choices are already made and the users are expected to sacrifice control for convenience.  


# Table of Contents
1. **[Preparation](#prepare-the-hard-drives)**
2. **[Prepare the storage devices](#prepare-the-hard-drives)**
  - **[Install the base packages](#installing-system-base)**
  - **[configuration-the-installation](#configuration-the-installation)**
4. **[Install Software](##install-software)**
5. **[Setup Yaourt](#yaourt)**
6. **[Getting Started with docker](#getting-started-with-docker)**
  - **[Create a machine](#create-a-machine)**
  - **[Run containers](#run-containers)**
6. **[Setup MySQL](#install-mysql)**
7. **[Setup Printer](#setup-printer)**
8. **[Setup NFS with Synology](#setup-network-file-system-nfs)**
9. **[Setup Cisco AnyConnect](#install-openconnect-cisco-anyconnect)**
10. **[Setup Android Development Environment](#android-development)**
11. **[Beautify Grub 2 Boot Loader](#beautify-grub-2-boot-loader-by-installing-themes)**
12. **[How to skip all Yaourt prompts on Arch Linux](#how-to-skip-all-yaourt-prompts-on-arch-linux)**
13. **[Update and Upgrade AUR packages with Yaourt](#upgrade-foreign-packages)**
14. **[Arch Linux Pacman tutorial](#arch-linux-pacman)**
15. **[C# Development](#c-development)**
    - **[Setup Visual Studio Code](#setup-visual-studio-code)**
    - **[Install C# Extension](#setup-c-extension)**
--

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


# Yaourt

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

![](https://github.com/sayems/Arch-Linux/blob/master/screenshot/aur-packages.png)

### Yaourt: No space left on device 

```
sudo nano /etc/yaourtrc
```

Change yaourt defualt folder to ~/home/tmp folder
```
# TMPDIR="/tmp"
TMPDIR="/home/$USER/tmp"
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

--


### Upgrade Foreign packages

```
yaourt -Syua
```

--


# Getting Started with docker

### Installation

For the normal package a simple
```bash
$ sudo pacman -S docker
```
is all that is needed.

For the AUR package execute:
```bash
$ sudo yaourt -S docker-git
```
The instructions here assume yaourt is installed. See [Arch User Repository](https://wiki.archlinux.org/index.php/Arch_User_Repository#Installing_packages) for information on building and installing packages from the AUR if you have not done so before.

### Starting Docker

There is a systemd service unit created for docker. To start the docker service:

```bash
$ sudo systemctl start docker
```
To start on system boot:

```bash
$ sudo systemctl enable docker
```

Add user to the docker group
```bash
$ sudo usermod -aG docker sayem
```

Logout and login as the user

## Create a machine

1. Open a command shell or terminal window.
These command examples shows a Bash shell. For a different shell, such as C Shell, the same commands are the same except where noted.

2. Use docker-machine ls to list available machines.
In this example, no machines have been created yet.

```bash
$ docker-machine ls
NAME   ACTIVE   DRIVER   STATE   URL   SWARM   DOCKER   ERRORS
```

3. Create a machine.

Run the ```docker-machine create``` command, passing the string ```virtualbox``` to the ```--driver``` flag. The final argument is the name of the machine. If this is your first machine, name it ```default```. If you already have a “default” machine, choose another name for this new machine.

```bash
$ docker-machine create --driver virtualbox default
Running pre-create checks...
Creating machine...
(staging) Copying /Users/ripley/.docker/machine/cache/boot2docker.iso to /Users/ripley/.docker/machine/machines/default/boot2docker.iso...
(staging) Creating VirtualBox VM...
(staging) Creating SSH key...
(staging) Starting the VM...
(staging) Waiting for an IP...
Waiting for machine to be running, this may take a few minutes...
Machine is running, waiting for SSH to be available...
Detecting operating system of created instance...
Detecting the provisioner...
Provisioning with boot2docker...
Copying certs to the local machine directory...
Copying certs to the remote machine...
Setting Docker configuration on the remote daemon...
Checking connection to Docker...
Docker is up and running!
To see how to connect Docker to this machine, run: docker-machine env default
```

This command downloads a lightweight Linux distribution [(boot2docker)](https://github.com/boot2docker/boot2docker) with the Docker daemon installed, and creates and starts a VirtualBox VM with Docker running.

4. List available machines again to see your newly minted machine.

```bash
$ docker-machine ls
NAME      ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER   ERRORS
default   *        virtualbox   Running   tcp://192.168.99.187:2376           v1.9.1
```
5. Get the environment commands for your new VM.
As noted in the output of the ```docker-machine create``` command, you need to tell Docker to talk to the new machine. You can do this with the ```docker-machine env``` command.

```bash
$ docker-machine env default
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://172.16.62.130:2376"
export DOCKER_CERT_PATH="/Users/<yourusername>/.docker/machine/machines/default"
export DOCKER_MACHINE_NAME="default"
# Run this command to configure your shell:
# eval "$(docker-machine env default)"
```

6. Connect your shell to the new machine.

```bash
$ eval "$(docker-machine env default)"
```

## Run containers

Run a container with ```docker run``` to verify your set up.

1. Use ```docker run``` to download and run ```busybox``` with a simple ‘echo’ command.

```bash
$ docker run busybox echo hello world
Unable to find image 'busybox' locally
Pulling repository busybox
e72ac664f4f0: Download complete
511136ea3c5a: Download complete
df7546f9f060: Download complete
e433a6c5b276: Download complete
hello world
```

2. Get the host IP address.

Any exposed ports are available on the Docker host’s IP address, which you can get using the docker-machine ip command:

```bash
$ docker-machine ip default
192.168.99.100
```

You can create and manage as many local VMs running Docker as you please; just run ```docker-machine create``` again. All created machines will appear in the output of ```docker-machine ls```.

--

#Install MySQL

To install MySQL, open terminal and type in these commands:

```
$ yaourt  mysql 
```
select mysql package and install it

 Once you have installed MySQL, start it running
 ```
$ sudo systemctl start mysqld
```

Finish up by running the MySQL set up script:
```
$ sudo mysql_secure_installation
```

Enable Autostart
```
$ sudo systemctl enable mysqld
```

Install MySQL Workbench
```
$ sudo pacman -S mysql-workbench
```

--

# Setup Printer

Install Brother HL-2270DW series driver

```bash
yaourt -S brother-hl2270dw
```
Install Brother MFC-J470DW driver
```bash
yaourt -S brother-mfc-j470dw
```

Install Cups libraries

```bash
yaourt -S libcups
pacman -S cups cups-filters ghostscript gsfonts
```

Enable cups so it starts with system boot
```bash
systemctl enable org.cups.cupsd.service
systemctl daemon-reload
```

Start CUPS
```bash
systemctl start org.cups.cupsd.service
```

Open the CUPS interface from this URL (http://localhost:631/admin) and log in as root. Here you can add and configure your printer.

--
# Setup Network File System (NFS)

Installation
```
$ pacman -S nfs-utils 
```

Start server
```
$ sudo systemctl enable rpcbind.service
$ sudo systemctl start rpcbind.service
$ sudo systemctl enable nfs-client.target
$ sudo systemctl start nfs-client.target
$ sudo systemctl start remote-fs.target
```

Manual mounting
Show the server's exported file systems:
```
$ showmount -e DiskStation 
```

Then mount omitting the server's NFS export root:
```
# sudo mount -t nfs DiskStation:/volume1/video /home/sayem/Videos
```
(Make sure Videos folder exist in /sayem/home/Videos)

--

### Install OpenConnect (Cisco AnyConnect)

Install the networkmanager-openconnect package from the Official repositories
```
$ sudo pacman -S networkmanager-openconnect
```

Download a more up-to-date script that OpenConnect will use to setup routing and DNS information (the only difference, currently, between this script and the one that comes with vpnc is using /usr/sbin/resolvconf instead of /sbin/resolvconf, there should be an AUR package for this eventually):

```
# wget http://git.infradead.org/users/dwmw2/vpnc-scripts.git/blob_plain/HEAD:/vpnc-script
```
Replace references to /sbin/resolvconf with /usr/bin/resolvconf:
```
$ sed -i 's/\/sbin\/resolvconf/\/usr\/bin\/resolvconf/g' vpnc-script
```
Make it executable:
```
$ chmod +x vpnc-script
```
Now run OpenConnect as root with the script downloaded above, and provide the gateway:
```
$ sudo openconnect --script ./vpnc-script https://vpn.system.com
```
It will ask you to enter GROUP Name:
```
Please enter your username and password.
GROUP: [User|Manager]: 
```
then,
```
Please enter your username and password.
Username:
Password:
```

Use ctrl-c to close and tear down the vpn connection.

--

### Android Development

```bash
yaourt -S android-studio
```

```bash
yaourt -S genymotion
```

```bash
sudo pacman -S virtualbox-host-dkms
````

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


## C# Development

