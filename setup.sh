#!/bin/bash

info() {
  echo -e "\033[1;34m$1\033[0m"
}

success() {
  echo -e "\033[1;32m$1\033[0m"
}

error() {
  echo -e "\033[1;31m$1\033[0m"
}

separator() {
  echo -e "\033[1;37m---------------------------------------------\033[0m"
}

clear

separator
info "Starting the setup process..."
separator

info "Step 1: Updating package lists..."
sudo apt update -y > /dev/null 2>&1
separator

info "Step 2: Installing Node.js, npm, and Certbot..."
sudo apt install -y nodejs npm certbot python3-certbot-nginx > /dev/null 2>&1
separator

info "Step 3: Please enter your subdomain (e.g., subdomain.example.com):"
read -p "Subdomain: " SUBDOMAIN

if [ -z "$SUBDOMAIN" ]; then
  error "No subdomain entered. Exiting."
  separator
  exit 1
fi

info "Step 4: Requesting SSL certificate for $SUBDOMAIN..."
sudo certbot --nginx -d $SUBDOMAIN
separator

success "SSL configuration complete for $SUBDOMAIN!"
separator

info "Step 5: Running conf.sh..."
sudo bash /sh/conf.sh > /dev/null 2>&1
separator

info "Step 6: Running updates.sh..."
sudo nohup bash /sh/updates.sh &> /updates.log &
separator

info "Step 7: Installing PM2..."
sudo npm install pm2 -g > /dev/null 2>&1
separator

info "Step 8: Configuring PM2 to start on boot..."
pm2 startup
separator

info "Step 9: Starting the application with PM2..."
pm2 start index.mjs
separator

success "🎉 Congratulations! Your setup is complete, and your domain is now live with Ulrua! 🎉 You can now safely close this terminal."
separator
