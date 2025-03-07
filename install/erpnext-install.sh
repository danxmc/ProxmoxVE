#!/usr/bin/env bash

# Copyright (c) 2021-2025 tteck
# Author: Daniel Alexandro Martínez (danxmc)
# License: MIT
# https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE

source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD apt-get install -y \
  curl \
  sudo \
  git
msg_ok "Installed Dependencies"

msg_info "Installing Python Dependencies"
$STD apt-get install -y \
  python3-dev \
  python3-pip \
  python-is-python3
rm -rf /usr/lib/python3.*/EXTERNALLY-MANAGED
msg_ok "Installed Python Dependencies"

msg_info "Installing MariaDB"
$STD apt-get install -y \
  mariadb-server \
  mariadb-client
systemctl enable -q --now mariadb-server
msg_ok "Installed MariaDb"

msg_info "Installing Redis"
$STD apt-get install -y redis-server
systemctl enable -q --now redis-server
msg_ok "Installed Redis"

msg_info "Installing Node.js"
$STD bash <(curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh)
. ~/.bashrc
$STD nvm install 18.20.7
ln -sf /root/.nvm/versions/node/v18.20.7/bin/node /usr/bin/node
$STD npm install -g yarn
msg_ok "Installed Node.js"

msg_info "Installing wkhtmltopdf"
WKHTMLTOPDF_RELEASE=$(curl -s https://api.github.com/repos/wkhtmltopdf/packaging/releases/latest | grep "tag_name" | awk '{print substr($2, 3, length($2)-4) }')
$STD apt-get install -y \
  xvfb \
  libfontconfig
wget -qO wkhtmltopdf.deb https://github.com/wkhtmltopdf/packaging/releases/download/${WKHTMLTOPDF_RELEASE}/wkhtmltox_${WKHTMLTOPDF_RELEASE}.bookworm_amd64.deb
msg_ok "Installed wkhtmltopdf"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get -y autoremove
$STD apt-get -y autoclean
msg_ok "Cleaned"
