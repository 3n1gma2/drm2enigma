#!/bin/bash
# Step 1: Install Dependencies
echo "Step 1: Installing Dependencies..."
sudo apt update
sudo apt -y install software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo add-apt-repository ppa:linuxuprising/java
sudo apt update

# Step 2: Install PHP AND NginX
echo "Step 2: Installing PHP and NginX..."
sudo apt -y install oracle-java17-installer
sudo apt -y install php7.4-fpm
sudo apt -y install php7.4-sqlite3
sudo apt -y install php7.4-curl
sudo apt -y install nginx
sudo apt -y install unzip

# Step 3: Copy Files to Server
echo "Step 3: Copying Files to Server..."
wget https://github.com/3n1gma2/drm2enigma/raw/main/drm2enigma.zip
unzip DRM2ENIGMA.zip -d /opt/share2box-drm

# Step 4: After Installation of Nginx
echo "Step 4: Configuring NginX..."
mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
mv /opt/share2box-drm/nginx.conf /etc/nginx/nginx.conf

# Step 5: Restart Services
echo "Step 5: Restarting Services..."
sudo systemctl reload nginx
sudo systemctl restart php7.4-fpm.service

# Step 6: Create Ramdisk
echo "Step 6: Creating Ramdisk..."
mkdir /tmp/ramdisk
chmod 777 /tmp/ramdisk
mount -t tmpfs -o size=1024M tmpfs /tmp/ramdisk

# Step 7: Install FFMPEG
echo "Step 7: Installing FFMPEG..."
wget https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz
tar -xf ffmpeg-release-amd64-static.tar.xz
cp ffmpeg-*-amd64-static/ffmpeg /usr/bin

# Step 8: Set Permissions
echo "Step 8: Setting Permissions..."
sudo chown www-data:www-data /opt/share2box-drm/channels_new.db
chgrp www-data /opt/share2box-drm/channels_new.db
chmod -R 777 /opt/

# Step 9: Start Service
echo "Step 9: Starting Service..."
bash /opt/share2box-drm/shell/service.sh start

# Step 10: Add Cronjob
echo "Step 10: Adding Cronjob..."
(crontab -l ; echo "@reboot nohup sh /opt/share2box-drm/shell/shell.events.sh > /dev/null &") | crontab -
(crontab -l ; echo "@reboot sh /opt/share2box-drm/shell/restartService.sh") | crontab -

echo "Installation and Configuration Completed Successfully!"
