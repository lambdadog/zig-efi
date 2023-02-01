#!/bin/sh

set -x

QEMU_BIN=$(nix-build '<nixpkgs>' --attr qemu --no-out-link)/bin
FD=$(nix-build '<nixpkgs>' --attr OVMF.fd --no-out-link)/FV/OVMF.fd

mkdir -p ovmf
cp ${FD} ovmf/OVMF.fd
chmod =rw ovmf/OVMF.fd

${QEMU_BIN}/qemu-system-x86_64 \
    -drive if=pflash,format=raw,file=ovmf/OVMF.fd \
    -drive format=raw,file=fat:rw:root \
    -net none
