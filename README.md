# Coder Setup Script

## Intro

This script sets up a [Code Server](https://github.com/cdr/code-server) instance on your VM using [Caddy](https://caddyserver.com/) as a reverse proxy with DNS-01 challenge to verify domain ownership and issue LetsEncrypt SSL certificates.

## Tested Distros

- Debian 10
- Ubuntu 16.04.7 LTS

## Requirements

- Linux VMs
- Curl installed
- Cloudflare "Full" SSL Setup
- Cloudflare Account with [API Token](https://developers.cloudflare.com/api/tokens/create) with these permissions:
  - Zone / Zone / Read
  - Zone / DNS / Edit

## Setup Instructions

1. Setup an A record pointing to you VM's public IP in Cloudflare
2. SSH onto the VM
3. Switch to root user and run the script (either sudo or login as root)

    ```bash
    bash <(curl -fsSL https://raw.githubusercontent.com/alec-hs/coder-hetzner-setup/main/setup.sh)
    ```

4. Access your Coder instance at your domain

## Port Proxy

Add more info here
