#!/usr/bin/env bash
set -eu

BUSY_BOX_DIR="${BUSY_BOX_DIR:-}"
ROOTFS_IMG="${ROOTFS_IMG:-ext4_100m.img}"
MNT_DIR="${MNT_DIR:-./tmp/mnt_rootfs}"

if [ -z "${BUSY_BOX_DIR}" ]; then
    echo "BUSY_BOX_DIR is not set."
    echo "Example: BUSY_BOX_DIR=/path/to/busybox-1.37.0/_install ./rootfs.sh"
    exit 1
fi

if [ ! -d "${BUSY_BOX_DIR}" ]; then
    echo "BusyBox install dir does not exist: ${BUSY_BOX_DIR}"
    exit 1
fi

if [ ! -f "${ROOTFS_IMG}" ]; then
    echo "Rootfs image does not exist: ${ROOTFS_IMG}"
    exit 1
fi

mkdir -p "${MNT_DIR}"
sudo mount -o loop "${ROOTFS_IMG}" "${MNT_DIR}"
sudo cp -a "${BUSY_BOX_DIR}"/. "${MNT_DIR}/"
sudo cp ../src/init.sh "${MNT_DIR}/init.sh"
sudo mkdir -p "${MNT_DIR}/root"
sudo chmod +x "${MNT_DIR}/init.sh"
sync
sudo umount "${MNT_DIR}"
