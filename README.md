# Coder Setup Script

A script to setup a Debian 10 VM with Coder running over HTTPS using Cloudflare.

## Requirements

- Debian 10
- Curl
- Cloudflare Account with API Token with these permissions:
  - Zone / Zone / Read
  - Zone / DNS / Edit

---

## Setup Instructions

1. Run the script to install

    ```bash
    curl -fsSL https://raw.githubusercontent.com/alec-hs/coder-hetzner-setup/main/setup.sh | sh 
    ```

2. Access your Coder instace at your domain
