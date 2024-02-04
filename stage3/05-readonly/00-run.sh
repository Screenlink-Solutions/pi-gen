#!/bin/bash -e

sed "${ROOTFS_DIR}/boot/cmdline.txt" -i -e 's/$/ fastboot noswap ro/'

on_chroot << EOF
apt-get install busybox-syslogd

mv /etc/resolv.conf /tmp/resolv.conf
rm -rf /var/lib/dhcp /var/lib/dhcpcd5 /var/run /var/spool /var/lock
ln -s /tmp /var/lib/dhcp
ln -s /tmp /var/lib/dhcpcd5
ln -s /tmp /var/spool
ln -s /tmp/resolv.conf /etc/resolv.conf
ln -s /tmp/random-seed /var/lib/systemd/random-seed
EOF

fstab=$(cat "${ROOTFS_DIR}/etc/fstab")
fstab=$(echo "${fstab}" | awk '$2~"^/$"{$4=$4",ro"}1' OFS="\t")
fstab=$(echo "${fstab}" | awk '$2~"^/boot/firmware$"{$4=$4",ro"}1' OFS="\t")
echo "${fstab}" > "${ROOTFS_DIR}/etc/fstab"

{
  echo 'tmpfs /tmp tmpfs nosuid,nodev 0 0'
  echo 'tmpfs /run tmpfs nosuid,nodev 0 0'
  echo 'tmpfs /run/lock tmpfs nosuid,nodev 0 0'
  echo 'tmpfs /var/log tmpfs nosuid,nodev 0 0'
  echo 'tmpfs /var/tmp tmpfs nosuid,nodev 0 0'
} >> "${ROOTFS_DIR}/etc/fstab"

