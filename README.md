# Dotfiles

This is a collection of my dotfiles.

To my future self: remember to be simple and minimalistic. We only want to keep the essentials.

## SO Actual - Arch Linux - Gnome 46

### Instalación Arch

En una unidad USB de Arch Linux Live arrancada, abre una terminal y ejecuta el siguiente commando para iniciar el proceso de instalación:

```bash
archinstall
```

1. Archinstall Language - English
2. Mirror region - 'spain' (or your country)
3. Locales - us
4. Disk configuration
	1. Use a best effort defualt partition layout - elige tu disco
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

### Agregar usuario

- Agregar usuario

```sh
useradd -m -g wheel <your_user>
```

- Crear contraseña para el usuario

```sh
passwd <your_user>
```

### Darle acceso a sudo

en usuario root ejecuta el siguiente commando

```sh
EDITOR=nano visudo
```

y descomenta esta línea para que se vea así

```sh
%wheel ALL=(ALL) ALL
```

si no quieres escribir tu contraseña cada vez, haz esto en su lugar

```sh
%wheel ALL=(ALL) NOPASSWD: ALL
```

Inicia sesión en el usuario recién creado

```bash
su - your_user_name
```
