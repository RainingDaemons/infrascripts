#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.func)
# Copyright (c) 2021-2026 community-scripts.org
# Author: RainingDaemons
# License: MIT
# Source: https://github.com/RainingDaemons/infrascripts

APP="PostgreSQL 16 LXC"
var_tags="${var_tags:-database;postgresql}"
var_cpu="${var_cpu:-2}"
var_ram="${var_ram:-2048}"
var_disk="${var_disk:-10}"
var_os="${var_os:-debian}"
var_version="${var_version:-12}"
var_unprivileged="${var_unprivileged:-1}"

header_info "$APP"
variables

# APP includes a display suffix, so set the actual companion installer filename explicitly.
var_install="postgresql-install"
color
catch_errors

# Override INSTALL_BASE_URL when hosting these scripts from a different Git remote.
INSTALL_BASE_URL="${INSTALL_BASE_URL:-https://raw.githubusercontent.com/RainingDaemons/infrascripts/main/database/postgresql}"
eval "$(declare -f build_container | sed "s#https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/install#${INSTALL_BASE_URL}#g")"

start
build_container
description

msg_ok "Completed successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
