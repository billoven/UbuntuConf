#!/bin/sh

# Get and install NFS client package
echo " --> Get, install and start NFS client package"
sudo apt-get install nfs-common

# Get and install autofs package
echo " --> Get, install and start autofs package (Start also NFS)"
sudo apt-get install autofs

# Copy auto.master and auto.srv in /etc
echo " --> Copy auto.master and auto.srv in /etc"
sudo cp -fp etc/auto.master /etc
sudo chmod 644 /etc/auto.master
sudo cp -fp etc/auto.srv /etc
sudo chmod 644 /etc/auto.srv

# Start autofs
echo " --> Restart autofs"
# sudo /etc/init.d/autofs restart
# From ubuntu 9.10
sudo service autofs restart
mount

# Wait 5 seconds
sleep 5

# DNS Configuration
echo " --> DNS Configuration - install resolvconf package"
echo " --> DNS Configuration - Copy DNS configuration in base file"
sudo apt-get install resolvconf
sudo cp etc/resolv.conf /etc/resolvconf/resolv.conf.d/base
sudo chmod 644 /etc/resolvconf/resolv.conf.d/base
sudo chown root /etc/resolvconf/resolv.conf.d/base
sudo chgrp root /etc/resolvconf/resolv.conf.d/base

# Create secondary group "villebon" add it to users
echo " --> Creation of villebon group with gid=1001"
sudo addgroup --gid 1001 villebon
echo " --> Add group villebon to user pierre"
sudo adduser pierre villebon

# Test automount on "photos resource"
echo " --> Test automount - cd /srv/photos" 
cd /srv/photos
ls

# Create symbolic links on linux desktop
echo " --> Create symbolic links on linux desktop" 
ln -s /srv/pierre /home/pierre/Bureau
ln -s /srv/photos /home/pierre/Bureau
ln -s /srv/musique /home/pierre/Bureau
ln -s /srv/video /home/pierre/Bureau
ln -s /srv/admin /home/pierre/Bureau

# Get and install VLC sound package (Install also VLC if not present)
echo " --> Install VLC sound package and also VLC if not present"
sudo apt-get install vlc

# Get and install Compiz-Fusion
#echo " --> Get and Install Compiz-Fusion"
#sudo apt-get install simple-ccsm

# Get and install Thunderbird mail
echo " --> Get and Install Thunderbird"
#sudo apt-get install thunderbird

