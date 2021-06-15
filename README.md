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

During the setup process of this script you will be asked to choose an option for port proxying. You can either set up a wildcard DNS entry for `*.mydomain.com` if your domain name registrar supports it or you can create one for every port you want to access (`3000.mydoamin.com`, `8080.mydoamin.com`, etc).

Due to the current setup of Coder you cannot have your code server instance on a subdomain of your proxy domain.

Additionally if you use Cloudflare Proxy (orange cloud) or Cloudflare Access it is recommnded you set DNS records for each port as the wildcard record is not supported by CF Access or CF Proxy.

## Known Issues

If you expiernce any issues such as repeated redirection to Code Server login screen or certifcate issues - make sure you wait a good 5 mins before trying again. These errors are often caused by a delay in the automated issuing of SSL Certs.
