#!/bin/bash

set -e

echo "========================================="
echo " Linux Remote Desktop Installer"
echo " XFCE + XRDP + Audio + Microphone"
echo "========================================="

echo ""
echo "[1/5] Updating system..."
sudo apt update && sudo apt upgrade -y

echo ""
echo "[2/5] Installing XFCE + XRDP..."
sudo apt install -y \
  xfce4 \
  xfce4-goodies \
  xrdp \
  xorgxrdp \
  dbus-x11

echo ""
echo "[3/5] Configuring XFCE session..."

printf '%s\n' 'exec startxfce4' > ~/.xsession
chmod +x ~/.xsession

echo ""
echo "[4/5] Installing Audio + Microphone support..."

sudo apt install -y \
  pipewire \
  pipewire-pulse \
  wireplumber \
  pipewire-module-xrdp \
  libpipewire-0.3-modules-xrdp \
  pavucontrol \
  xfce4-pulseaudio-plugin

echo ""
echo "[5/5] Enabling XRDP..."

sudo systemctl enable --now xrdp

echo ""
echo "Configuring firewall..."

sudo ufw allow 3389/tcp

echo ""
echo "========================================="
echo " Installation Complete! 🎉"
echo "========================================="
echo ""
echo "Features installed:"
echo "  ✓ XFCE Desktop"
echo "  ✓ XRDP Remote Desktop"
echo "  ✓ Remote Audio Output"
echo "  ✓ Remote Microphone Input"
echo "  ✓ PipeWire"
echo "  ✓ WirePlumber"
echo "  ✓ XRDP Audio Module"
echo "  ✓ PulseAudio/PipeWire Controls"
echo ""
echo "Reboot your server using:"
echo ""
echo "sudo reboot"
echo ""
