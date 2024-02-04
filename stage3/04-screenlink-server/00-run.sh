#!/bin/bash -e

RELEASE_API_URL="https://api.github.com/repos/Screenlink-Solutions/screenlink-server/releases/latest"
GITHUB_API_HEADER="Authorization: Bearer $GITHUB_API_TOKEN"
SERVER_DOWNLOAD_URL=$(curl -s $RELEASE_API_URL -H "$GITHUB_API_HEADER" | jq -r '.assets[] | select(.name | contains("linux-arm64")) | select(.name | endswith(".tar.gz")) | .url')

curl -s "$SERVER_DOWNLOAD_URL" -L -H "$GITHUB_API_HEADER" -H "Accept: application/octet-stream" -o "${STAGE_WORK_DIR}/screenlink-server.tar.gz"

tar -xvf "${STAGE_WORK_DIR}/screenlink-server.tar.gz" -C "${STAGE_WORK_DIR}"
install -m 755 "${STAGE_WORK_DIR}/screenlink-server" "${ROOTFS_DIR}/usr/local/sbin/"
install -m 644 files/screenlink-server.service "${ROOTFS_DIR}/lib/systemd/system/"

on_chroot << EOF
systemctl enable screenlink-server.service
EOF
