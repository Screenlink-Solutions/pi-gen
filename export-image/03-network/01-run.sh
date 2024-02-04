#!/bin/bash -e

install -m 644 files/resolv.conf "${ROOTFS_DIR}/etc/"

#install -m 644 files/resolv.conf "${ROOTFS_DIR}/tmp/"
#on_chroot << EOF
#rm -rf /etc/resolv.conf
#ln -s /tmp/resolv.conf /etc/resolv.conf
#EOF
