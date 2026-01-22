
### Arch Installation

On a bootable USB drive with Arch Linux Live, open a terminal and run the following command to start the installation process:

```bash
archinstall
```

1. Archinstall Language - English
2. Mirror region - 'spain' (or your country)
3. Locales - us
4. Disk configuration
	1. Use a best effort default partition layout - choose your disk
	2. Filesystem - ext4
	3. Partition /home - no
5. Disk encryption - none
6. Bootloader - grub-install
7. Swap - true
8. Hostname - arch_ansango
9. Root pass - \*\*\*
10. User account - none
11. Profile - minimal
12. Audio - pipewire
13. Kernels: linux
14. Additional packages - nano git
15. Network configuration - Use Networkmanager
16. Timezone - UTC
17. Automatic Time Sync (NTP) - true
18. Optional repositories - multilib

Would you like to chroot into the newly created installation?

> Yes

### Add User

- Add user

```sh
useradd -m -g wheel <your_user>
```

- Set a password for the user

```sh
passwd <your_user>
```

### Grant sudo access

As the root user, run the following command:

```sh
EDITOR=nano visudo
```

And uncomment this line so it looks like this:

```sh
%wheel ALL=(ALL) ALL
```

If you don't want to enter your password every time, do this instead:

```sh
%wheel ALL=(ALL) NOPASSWD: ALL
```

Log in to the newly created user:

```bash
su - your_user_name
```
### Install dotfiles

Reboot your machine and log with your user

```bash
su - your_user_name
```

Clone the repository

```bash
git clone https://github.com/ansango/dotfiles.git
```

Execute post-install.sh

```bash
sh post-install.sh
```
