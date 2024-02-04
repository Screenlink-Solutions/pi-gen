#!/bin/bash -e

install -m 755 files/firstboot "${ROOTFS_DIR}/usr/local/sbin/"
install -m 644 files/firstboot.service "${ROOTFS_DIR}/lib/systemd/system/"

on_chroot << EOF
systemctl enable firstboot.service
EOF

rm "${ROOTFS_DIR}/etc/hostname"
