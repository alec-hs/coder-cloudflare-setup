#!/bin/bash

# Start Script and ask for info
echo "------------------------------------------------------------"
echo
echo "              Code Server Automated Setup"
echo "                       alec-hs"
echo "    https://github.com/alec-hs/coder-cloudflare-setup"
echo
echo "------------------------------------------------------------"
echo
read -s -p "Please enter a password for Coder web GUI: " password
echo
echo
read -p "Please enter your domain: " domain
echo
read -s -p "Please enter your Cloudflare API Token: " token
echo
echo
echo "------------------------------------------------------------"
echo
echo "         Setting up Caddy and Coder services..."
echo
echo "------------------------------------------------------------"

# Hash the password
hash=$(printf $password | sha256sum | cut -d' ' -f1)

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

# Download caddy file from repo and replace default
curl https://raw.githubusercontent.com/alec-hs/coder-cloudflare-setup/main/code-server.service --output /etc/systemd/system/code-server.service

# Run Coder & run on boot
systemctl enable --now code-server

# Install go to build custom Caddy
wget https://golang.org/dl/go1.16.4.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.16.4.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
rm -rf go1.16.4.linux-amd64.tar.gz
rm -rf go

# Enable Go Modules
go env -w GO111MODULE="auto"

# Install Caddy & xCaddy
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/cfg/gpg/gpg.155B6D79CA56EA34.key' | sudo apt-key add -
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/cfg/setup/config.deb.txt?distro=debian&version=any-version' | sudo tee -a /etc/apt/sources.list.d/caddy-stable.list

curl -1sLf 'https://dl.cloudsmith.io/public/caddy/xcaddy/gpg.key' | sudo apt-key add -
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/xcaddy/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-xcaddy.list
sudo apt update -y
sudo apt install caddy xcaddy -y

# Build Caddy with Cloudflare DNS then replace exisiting binary
xcaddy build master --with github.com/caddy-dns/cloudflare@latest
mv caddy /usr/bin

# Download caddy file from repo and replace default
curl https://raw.githubusercontent.com/alec-hs/coder-cloudflare-setup/main/Caddyfile --output /etc/caddy/Caddyfile

# Update Caddyfile 
sed -i.bak "s/sub.mydomain.com/$domain/" /etc/caddy/Caddyfile
sed -i.bak "s/API_TOKEN/$token/" /etc/caddy/Caddyfile

# Update Coder config in /home/coder/.config/code-server/config.yaml
sed -i.bak "s/password: .*/hashed-password: $hash/" /home/coder/.config/code-server/config.yaml

# Reload Caddy and Coder
sudo systemctl stop code-server
sudo systemctl start code-server
sudo systemctl stop caddy
sudo systemctl start caddy



# Script Complete
echo
echo "------------------------------------------------------------"
echo
echo "                      Setup complete"
echo
echo "                 Code Server will be ready at"
echo
echo "https://$domain"
echo
echo "                      in a few minutes."
echo
echo "------------------------------------------------------------"