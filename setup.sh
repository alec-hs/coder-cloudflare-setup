#!/bin/bash

# Start Script
echo
echo "Installing Coder and requirements..."
echo

# Update server
sudo apt update -y && sudo apt upgrade -y

# Install git
sudo apt install git -y

# Create a code-server user
adduser --disabled-password --gecos "" coder
echo "coder ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/coder
usermod -aG sudo coder

# Copy ssh keys from root
cp -r /root/.ssh /home/coder/.ssh
chown -R coder:coder /home/coder/.ssh

# Download & install Coder
curl -fsSL https://code-server.dev/install.sh | sh

# Run Coder & run on boot
systemctl enable --now code-server@coder

# Ask user for coder password
echo
echo "Please enter a password for Coder web GUI:"
read -s password
echo

# Hash the password
hash=$(echo $password | sha256sum | cut -d' ' -f1)

# Update Coder config in /home/coder/.config/code-server/config.yaml
sed -i.bak "s/password: .*/hash-password: $hash/" /home/coder/.config/code-server/config.yaml

# Install go to build custom Caddy
wget https://golang.org/dl/go1.16.4.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.16.4.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
rm -rf go1.16.4.linux-amd64.tar.gz

# Enable Go Modules
go env -w GO111MODULE="auto"

# Install Caddy & xCaddy
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/cfg/gpg/gpg.155B6D79CA56EA34.key' | sudo apt-key add -
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/cfg/setup/config.deb.txt?distro=debian&version=any-version' | sudo tee -a /etc/apt/sources.list.d/caddy-stable.list

curl -1sLf 'https://dl.cloudsmith.io/public/caddy/xcaddy/gpg.key' | sudo apt-key add -
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/xcaddy/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-xcaddy.list
sudo apt update
sudo apt install caddy xcaddy -y

# Build Caddy with Cloudflare DNS then replace exisiting binary
xcaddy build master --with github.com/caddy-dns/cloudflare@latest
mv caddy /usr/bin

# Ask user for Caddy info
echo
echo "Please enter your domain:"
read domain
echo
echo "Please enter your Cloudflare API Token:"
read -s token
echo

# Download caddy file from repo and replace default
curl https://raw.githubusercontent.com/alec-hs/coder-hetzner-setup/main/Caddyfile --output /etc/caddy/Caddyfile

# Update Caddyfile 
sed -i.bak "s/sub.mydomain.com/$domain/" /etc/caddy/Caddyfile
sed -i.bak "s/API_TOKEN/$token/" /etc/caddy/Caddyfile

# Reload Caddy
sudo systemctl stop caddy
sudo systemctl start caddy

# Script Complete
echo
echo "Script complete - you can acess Coder at https://$domain"
echo