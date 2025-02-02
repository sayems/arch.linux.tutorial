Here is a step-by-step guide to install Arch Linux on a 2012 Mac Mini. This guide assumes you're familiar with the Arch Linux installation process and provides clear steps tailored to your hardware configuration.


---

### Step 1: Boot from Arch Linux Live USB

1. **Download the Arch Linux ISO** from the official website.
2. Create a bootable USB drive using the ISO.
3. Insert the USB stick into the Mac Mini and power it on. Hold the **Option** key to access the boot menu.
4. Select the **Arch Linux** boot option.

---

### Step 2: Partition the Disk

### Example of a partition table:
| Partition     | Size       | Mount Point   | File System |
|---------------|------------|---------------|-------------|
| /dev/sda1     | 512 MB     | /boot/efi     | vfat        |
| /dev/sda2     | 50 GB      | /             | ext4        |
| /dev/sda3     | 200 GB     | /home         | ext4        |
| /dev/sda4     | 8 GB       | swap          | swap        |

---

1. **Start `cfdisk`** to partition the disk:
   ```bash
   cfdisk /dev/sda
   ```

2. **Create the EFI partition (1GB)**:
   - Select the unallocated space, create a new partition of 1GB, and set the type to `EFI System` (type `ef00`).
   
3. **Create the Root partition (50GB)**:
   - Select the remaining space and create a partition of 50GB. Set the type to `Linux filesystem` (type `8300`).

4. **Create the Home partition (155.47GB)**:
   - Create a partition of 155.47GB for `/home`.

5. **Create the Swap partition (32GB)**:
   - Create a 32GB partition and set the type to `Linux swap` (type `8200`).

---

### Step 3: Format the Partitions

1. **Format the EFI partition**:
   ```bash
   mkfs.fat -F 32 /dev/sda1
   ```

2. **Format the Root partition**:
   ```bash
   mkfs.ext4 /dev/sda2
   ```

3. **Format the Home partition**:
   ```bash
   mkfs.ext4 /dev/sda3
   ```

4. **Format the Swap partition**:
   ```bash
   mkswap /dev/sda4
   ```

5. **Enable Swap**:
   ```bash
   swapon /dev/sda4
   ```

---

### Step 4: Mount the Partitions

1. **Mount the Root partition**:
   ```bash
   mount /dev/sda2 /mnt
   ```

2. **Create and mount the Home partition**:
   ```bash
   mkdir /mnt/home
   mount /dev/sda3 /mnt/home
   ```

3. **Mount the EFI partition**:
   ```bash
   mkdir /mnt/boot
   mount /dev/sda1 /mnt/boot
   ```

---

### Step 5: Install the Base System

1. **Install the base system**:
   ```bash
   pacstrap /mnt base linux linux-firmware nano
   ```

2. **Generate `fstab`**:
   ```bash
   genfstab -U /mnt >> /mnt/etc/fstab
   ```

3. **Change root into the installed system**:
   ```bash
   arch-chroot /mnt
   ```

---

### Step 6: Set Time Zone and Locale

1. **Set the time zone to New York City** (adjust if needed):
   ```bash
   ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
   hwclock --systohc
   ```

2. **Uncomment the `en_US.UTF-8` locale** in `/etc/locale.gen`:
   ```bash
   nano /etc/locale.gen
   # Uncomment en_US.UTF-8 UTF-8
   ```

3. **Generate locales**:
   ```bash
   locale-gen
   ```

4. **Set the system locale**:
   ```bash
   echo LANG=en_US.UTF-8 > /etc/locale.conf
   ```

5. **Set the hostname**:
   ```bash
   echo "linux" > /etc/hostname
   ```

6. **Configure `/etc/hosts`**:
   ```bash
   nano /etc/hosts
   ```
   Add the following lines:
   ```
   127.0.0.1       localhost
   ::1             localhost
   127.0.1.1       linux.localdomain linux
   ```

---

### Step 7: Install Bootloader (EFI)

1. **Install the GRUB bootloader**:
   ```bash
   pacman -S grub efibootmgr
   ```

2. **Install GRUB to the EFI partition**:
   ```bash
   grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB --recheck
   ```

3. **Generate the GRUB configuration**:
   ```bash
   grub-mkconfig -o /boot/grub/grub.cfg
   ```

---

### Step 8: Network Configuration

1. **Install `NetworkManager` and enable DHCP**:
   ```bash
   pacman -S networkmanager 
   ```

2. **Enable and start `NetworkManager`**:
   ```bash
   systemctl enable NetworkManager
   systemctl start NetworkManager
   ```

3. **Install Broadcom WiFi drivers** (if applicable):
   ```bash
   pacman -Sy broadcom-wl (If not available)
   sudo modprobe wl
   ```
   Then, install `broadcom-wl-dkms`
   ```
   pacman -Sy broadcom-wl-dkms
   sudo modprobe wl  (If it throw error)
   ```
   Then, install `linux-headers`
   ```
   sudo pacman -S linux-headers
   sudo modprobe wl
   ```

---

### Step 9: Enable Multilib Repository

To enable the multilib repository, uncomment the `[multilib]` section in `/etc/pacman.conf`:

```bash
nano /etc/pacman.conf
```

Scroll down and un-comment the `[multilib]` repo:
```
[multilib]
Include = /etc/pacman.d/mirrorlist
```

---

### Step 10: Add User and Install sudo

1. **Create a new user** (replace `sayem` with your username):
   ```bash
   useradd -m -g users -G wheel,storage,power,lp,network,audio,video,optical -s /bin/bash sayem
   passwd sayem
   ```

2. **Install `sudo`**:
   ```bash
   pacman -Sy sudo
   ```

3. **Allow the user to use `sudo`** by editing the sudoers file:
   ```bash
   visudo
   ```
   Uncomment the line:
   ```
   %wheel ALL=(ALL) ALL
   ```

---

### Step 11: Install Video Drivers

For Intel graphics on your Mac Mini, install the appropriate drivers:

```bash
pacman -S xf86-video-intel mesa
```

---

### Step 12: Install GNOME (Graphical Environment)

1. **Install GNOME and GNOME extras**:
   ```bash
   pacman -S gnome gnome-extra gdm
   ```

2. **Enable and start GDM (GNOME Display Manager)**:
   ```bash
   systemctl enable gdm
   ```

---

### Step 13: Install yay (AUR Helper)

1. **Install `base-devel` and `git` if not already installed**:
   ```bash
   pacman -S --needed base-devel git
   ```

2. **Clone and build `yay` (AUR helper)**:
   ```bash
   cd /home/sayem
   git clone https://aur.archlinux.org/yay.git
   cd yay
   makepkg -si
   ```

---

### Step 14: Reboot

1. **Exit chroot and unmount partitions**:
   ```bash
   exit
   umount -R /mnt
   reboot
   ```

2. Remove the USB stick, and the Mac Mini should boot into Arch Linux with GNOME.

---

### Additional Setup (Optional)

- Install additional software with `pacman` or `yay` for productivity, media, etc.
- Configure hardware (Wi-Fi, touchpad, etc.) using `pacman` or AUR packages.

This installation guide should provide a solid Arch Linux setup on your 2012 Mac Mini with a graphical environment.
