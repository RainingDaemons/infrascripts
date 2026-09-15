# InfraScripts

Proxmox LXC deployment scripts for lightweight development and infrastructure containers. Each deployment script uses the [Proxmox VE Community Scripts](https://community-scripts.github.io/ProxmoxVE/) build helpers to create a Debian 12 container and then invokes its matching installer.

## Repository layout

```text
infrascripts/
├── backend/
│   └── rust/
│       ├── rust.sh
│       └── rust-install.sh
├── database/
│   └── postgresql/
│       ├── postgresql.sh
│       └── postgresql-install.sh
└── frontend/
    └── nodejs/
        ├── nodejs.sh
        └── nodejs-install.sh
```

## Deploy a container

Run the deployment script from a Proxmox VE host as `root`:

```bash
# Rust development environment
bash -c "$(curl -fsSL https://raw.githubusercontent.com/RainingDaemons/infrascripts/main/backend/rust/rust.sh)"

# PostgreSQL 16 database
bash -c "$(curl -fsSL https://raw.githubusercontent.com/RainingDaemons/infrascripts/main/database/postgresql/postgresql.sh)"

# Node.js and pnpm development environment
bash -c "$(curl -fsSL https://raw.githubusercontent.com/RainingDaemons/infrascripts/main/frontend/nodejs/nodejs.sh)"
```

The scripts default to an unprivileged Debian 12 LXC with 2 vCPUs, 2 GB RAM, and a 10 GB disk. Community Scripts' standard prompts allow these values to be changed before creation.

## Included environments

| Environment | Installed software | Firewall ports |
| --- | --- | --- |
| Rust | Rust/Cargo, Node.js 22, Python 3 with pip, Git, build tools | TCP 22, 3000 |
| PostgreSQL | PostgreSQL 16, Node.js 22, Python 3 with pip, Git | TCP 5432 |
| Node.js | Node.js 22, pnpm, Python 3 with pip, Git | TCP 22, 5173, 5174 |

NOTES:
- All environments install and enable UFW. 
- The Rust and Node.js containers also configure `PermitRootLogin yes` in SSH. 

Restrict network access appropriately for production deployments, particularly before exposing SSH or PostgreSQL beyond a trusted network.

## Custom installer location

Each deployment script uses an `INSTALL_BASE_URL` environment variable to locate its companion `*-install.sh` file. It defaults to this repository's `main` branch. Override it when testing a fork or a different branch:

```bash
INSTALL_BASE_URL="https://raw.githubusercontent.com/your-account/infrascripts/your-branch/backend/rust" \
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/RainingDaemons/infrascripts/main/backend/rust/rust.sh)"
```
