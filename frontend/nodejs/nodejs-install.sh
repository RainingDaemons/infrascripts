#!/usr/bin/env bash

# Copyright (c) 2021-2026 community-scripts.org
# Author: RainingDaemons
# License: MIT
# Source: https://github.com/RainingDaemons/infrascripts

source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing system dependencies"
$STD apt-get install -y ca-certificates curl git python3 python3-pip ufw
msg_ok "Installed system dependencies"

msg_info "Installing Node.js and pnpm"
$STD curl --retry 3 --retry-delay 2 --retry-connrefused -fsSL -o /tmp/nodesource_setup.sh https://deb.nodesource.com/setup_22.x
$STD bash /tmp/nodesource_setup.sh
$STD rm -f /tmp/nodesource_setup.sh
$STD apt-get install -y nodejs
$STD npm install -g pnpm
msg_ok "Installed Node.js and pnpm"

msg_info "Configuring UFW"
$STD ufw allow 22/tcp
$STD ufw allow 5173/tcp
$STD ufw allow 5174/tcp
$STD ufw --force enable
msg_ok "Opened TCP ports 22, 5173, and 5174"

msg_info "Permitting SSH root login"
$STD sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
$STD systemctl restart ssh
msg_ok "Configured SSH root login"

motd_ssh
cleanup_lxc
