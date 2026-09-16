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
$STD apt-get install -y ca-certificates curl git gnupg python3 python3-pip ufw
msg_ok "Installed system dependencies"

msg_info "Installing Node.js"
$STD curl --retry 3 --retry-delay 2 --retry-connrefused -fsSL -o /tmp/nodesource_setup.sh https://deb.nodesource.com/setup_22.x
$STD bash /tmp/nodesource_setup.sh
$STD rm -f /tmp/nodesource_setup.sh
$STD apt-get install -y nodejs
msg_ok "Installed Node.js"

msg_info "Installing PostgreSQL 16"
$STD install -d -m 0755 /usr/share/postgresql-common/pgdg
$STD curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.gpg
. /etc/os-release
echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.gpg] https://apt.postgresql.org/pub/repos/apt ${VERSION_CODENAME}-pgdg main" > /etc/apt/sources.list.d/pgdg.list
$STD apt-get update
$STD apt-get install -y postgresql-16
msg_ok "Installed PostgreSQL 16"

msg_info "Configuring UFW"
$STD ufw allow 5432/tcp
$STD ufw --force enable
msg_ok "Opened TCP port 5432"

motd_ssh
cleanup_lxc
