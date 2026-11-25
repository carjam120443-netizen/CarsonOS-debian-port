# CarsonOS Debian Port

CarsonOS Debian Port is an independent Debian Stable-based live operating system.

## Current build target

- Debian 13 (Trixie) Stable
- x86_64 / amd64
- XFCE desktop with LightDM
- NetworkManager
- Firefox ESR
- Debian Live boot environment
- Hybrid ISO image for BIOS and UEFI boot

This repository is intentionally independent of the other CarsonOS projects.

## Build with GitHub Actions

1. Open the **Actions** tab.
2. Select **Build CarsonOS Live ISO**.
3. Choose **Run workflow**.
4. When the job completes, download the `CarsonOS-live-iso` artifact.

The workflow builds the ISO from Debian's Trixie repositories. It does not install anything onto the runner's host system.

## Build locally

Use a Debian 13 (Trixie) amd64 machine or VM with internet access:

```bash
sudo apt update
sudo apt install -y live-build debootstrap squashfs-tools xorriso   isolinux syslinux-common syslinux-utils grub-pc-bin grub-efi-amd64-bin   mtools dosfstools
sudo ./scripts/build.sh
```

The generated hybrid ISO is normally named `live-image-amd64.hybrid.iso` in the repository root.

## Test without installing

With QEMU installed:

```bash
qemu-system-x86_64 -m 4096 -cdrom live-image-amd64.hybrid.iso -boot d
```

For UEFI testing, use a QEMU OVMF firmware setup.

## Current scope

This first milestone is a bootable live desktop. It is **not yet an installed-system installer**. Calamares integration, persistent storage, custom branding, and an installed-system configuration will be added and tested as separate milestones.

## Safety

Test the ISO in a virtual machine first. Do not select or format a physical disk unless you intentionally move on to a future installation workflow and have verified the target disk.
