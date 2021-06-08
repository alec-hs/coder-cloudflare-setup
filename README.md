# Coder Setup Script

## Intro

This script sets up a Code Server instance on your VM using Caddy as a reverse proxy with DNS-01 challenge to verify domain ownership and issue LetsEncrypt SSL certificates.

<br>

---

<br>

## Tested Distros

- Debian 10
- Ubuntu 16.04.7 LTS

<br>

---

<br>

## Requirements

- Linux VMs
- Curl installed
- Cloudflare "Full" SSL Setup
- Cloudflare Account with API Token with these permissions:
  - Zone / Zone / Read
  - Zone / DNS / Edit

<br>

---

<br>

## Setup Instructions

1. Setup an A record pointing to you VM's public IP in Cloudflare
2. SSH onto the VM
3. Switch to root user
4. Run the script to install

    ```bash
    bash <(curl -fsSL https://raw.githubusercontent.com/alec-hs/coder-hetzner-setup/main/setup.sh)
    ```

5. Access your Coder instance at your domain
