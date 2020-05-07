#!/bin/bash

# Update system
echo "Updating system..."
apt update && apt upgrade -y

# Install main software
echo "\n\nInstalling basic software..."
apt install postgresql python3 python3-venv golang-go -y
# Set go PATH
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bashrc
source ~/.bashrc
mkdir $HOME/go

# Create user for ci
echo "\n\nCreating user 'gitlab' for ci"
useradd -m -G users,sudo gitlab
echo "$(tput setaf 2)Do not forget to change password for user 'gitlab'$(tput sgr 0)"
chsh -s /bin/bash gitlab

# Install Caddy
echo "\n\nBuildning Caddy server..."
go get github.com/mholt/caddy/caddy
cd $GOPATH/src/github.com/mholt/caddy
go install github.com/mholt/caddy/caddy
cp $GOPATH/bin/caddy /usr/local/bin/
# Fix permissions
chown root:root /usr/local/bin/caddy
chmod 755 /usr/local/bin/caddy
setcap 'cap_net_bind_service=+ep' /usr/local/bin/caddy
# Create Caddy stuff and test host
mkdir -p /etc/caddy/vhosts.d/
echo "import ./vhosts.d/*" > /etc/caddy/Caddyfile
IP=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')
echo -e "$IP:80 {\n\troot /var/www/test\n}" > /etc/caddy/vhosts.d/test
chown -R root:www-data /etc/caddy
mkdir /etc/ssl/caddy
chown -R root:www-data /etc/ssl/caddy
chmod 0770 /etc/ssl/caddy
mkdir /var/www
chown -R www-data:www-data /var/www
# Create service to run caddy
cp $GOPATH/src/github.com/mholt/caddy/dist/init/linux-systemd/caddy.service /etc/systemd/system/
chmod 644 /etc/systemd/system/caddy.service
systemctl daemon-reload
systemctl enable caddy
echo "$(tput setaf 2)To add hosts add files to /etc/caddy/vhosts.d directory$(tput sgr 0)"
