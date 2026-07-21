#!/bin/bash

echo "Removing XFCE and XRDP..."

sudo systemctl stop xrdp

sudo apt remove --purge -y xfce4 xfce4-goodies xrdp dbus-x11

sudo apt autoremove -y

echo "Uninstallation completed successfully."
