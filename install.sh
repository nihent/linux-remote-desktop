#!/bin/bash

sudo apt update && sudo apt upgrade -y

sudo apt install -y xfce4 xfce4-goodies xrdp dbus-x11

echo "xfce4-session" > ~/.xsession

sudo systemctl enable --now xrdp

sudo ufw allow 3389/tcp

echo "Installation Complete!"
echo "Reboot using:"
echo "sudo reboot"
