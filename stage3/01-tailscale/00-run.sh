#!/bin/bash -e

curl -fsSL "https://pkgs.tailscale.com/stable/debian/${RELEASE}.noarmor.gpg" > "${STAGE_WORK_DIR}/tailscale-archive-keyring.gpg"
curl -fsSL "https://pkgs.tailscale.com/stable/debian/${RELEASE}.tailscale-keyring.list" > "${STAGE_WORK_DIR}/tailscale.list"

install -m 644 "${STAGE_WORK_DIR}/tailscale-archive-keyring.gpg" "${ROOTFS_DIR}/usr/share/keyrings/"
install -m 644 files/tailscale.list "${ROOTFS_DIR}/etc/apt/sources.list.d/"
sed -i "s/RELEASE/${RELEASE}/g" "${ROOTFS_DIR}/etc/apt/sources.list.d/tailscale.list"

install -m 644 -D files/override.conf "${ROOTFS_DIR}/etc/systemd/system/tailscaled.service.d/override.conf"

on_chroot << EOF
apt-get update
apt-get install -y tailscale

echo 'net.ipv4.ip_forward = 1' | tee -a /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' | tee -a /etc/sysctl.d/99-tailscale.conf
sysctl -p /etc/sysctl.d/99-tailscale.conf

tailscale set --ssh
tailscale set --advertise-exit-node
EOF
