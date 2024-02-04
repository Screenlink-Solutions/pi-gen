#!/bin/bash -e

curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor --yes -o "${STAGE_WORK_DIR}/redis-archive-keyring.gpg"

install -m 644 "${STAGE_WORK_DIR}/redis-archive-keyring.gpg" "${ROOTFS_DIR}/usr/share/keyrings/"
install -m 644 files/redis.list "${ROOTFS_DIR}/etc/apt/sources.list.d/"
sed -i "s/RELEASE/${RELEASE}/g" "${ROOTFS_DIR}/etc/apt/sources.list.d/redis.list"

on_chroot << EOF
apt-get update
apt-get install -y redis
systemctl enable redis-server.service
EOF
