#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if [[ "$EUID" -ne 0 ]]; then
  echo "Run this script as root: sudo ./scripts/build.sh" >&2
  exit 1
fi

for command in lb debootstrap mksquashfs xorriso; do
  if ! command -v "$command" >/dev/null 2>&1; then
    echo "Missing required command: $command" >&2
    echo "Install the build dependencies listed in README.md." >&2
    exit 1
  fi
done

export DEBIAN_FRONTEND=noninteractive

echo "==> Cleaning previous CarsonOS build output"
lb clean --purge

# Keep our source-controlled package lists, but regenerate live-build's
# derived settings so changed options are never shadowed by stale config.
rm -f config/binary config/bootstrap config/chroot config/common config/source

echo "==> Configuring Debian 13 Trixie amd64 hybrid live ISO"
lb config \
  --distribution trixie \
  --architectures amd64 \
  --binary-images iso-hybrid \
  --bootloaders grub-efi,syslinux \
  --uefi-secure-boot auto \
  --checksums sha256 \
  --archive-areas "main contrib non-free non-free-firmware" \
  --apt-recommends true \
  --apt-indices false \
  --iso-application "CarsonOS Debian" \
  --iso-volume "CARSONOS_LIVE" \
  --bootappend-live "boot=live components username=carson hostname=carsonos"

echo "==> Building CarsonOS live ISO"
lb build

ISO_PATH="live-image-amd64.hybrid.iso"
if [[ ! -s "$ISO_PATH" ]]; then
  echo "Build finished but expected ISO was not found: $ISO_PATH" >&2
  echo "Files produced:" >&2
  find . -maxdepth 2 -type f -name '*.iso' -print >&2
  exit 1
fi

echo "==> ISO created: $ROOT_DIR/$ISO_PATH"
ls -lh "$ISO_PATH"
