#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.func)
# Copyright (c) 2021-2025 tteck
# Author: Daniel Alexandro Martínez (danxmc)
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: https://frappe.io/erpnext

APP="ERPNext"
var_tags="erp"
var_cpu="2"
var_ram="4096"
var_disk="40"
var_os="debian"
var_version="12"
var_unprivileged="1"

header_info "$APP"
variables
color
catch_errors

function update_script() {
  header_info
  check_container_storage
  check_container_resources
  if [[ ! -d /opt/ERPNext ]]; then
    msg_error "No ${APP} Installation Found!"
    exit
  fi
  msg_info "Updating ${APP}"
  systemctl stop erpnext
  if [[ -n $(dpkg -l | grep -w ocrmypdf) ]] && [[ -z $(dpkg -l | grep -w qpdf) ]]; then
    $STD apt-get remove -y ocrmypdf
    $STD apt-get install -y qpdf
  fi
  RELEASE=$(curl -s https://api.github.com/repos/Stirling-Tools/Stirling-PDF/releases/latest | grep "tag_name" | awk '{print substr($2, 3, length($2)-4) }')
  msg_ok "Updated ${APP} to v$RELEASE"
  exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Access it using the following URL:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}http://${IP}:8080${CL}"