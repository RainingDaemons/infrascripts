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
$STD apt-get install -y ca-certificates curl git python3 python3-pip ufw build-essential
msg_ok "Installed system dependencies"

msg_info "Installing Node.js"
$STD curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
$STD apt-get install -y nodejs
msg_ok "Installed Node.js"

msg_info "Installing Rust and Cargo"
export CARGO_HOME=/root/.cargo
export RUSTUP_HOME=/root/.rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
. "${CARGO_HOME}/env"
msg_ok "Installed Rust and Cargo"

msg_info "Configuring UFW"
$STD ufw allow 22/tcp
$STD ufw allow 3000/tcp
$STD ufw --force enable
msg_ok "Opened TCP ports 22 and 3000"

msg_info "Permitting SSH root login"
$STD sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
$STD systemctl restart ssh
msg_ok "Configured SSH root login"

motd_ssh
cleanup_lxc
