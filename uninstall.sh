#!/bin/bash

set -e

echo "========================================="
echo " Linux Remote Desktop Uninstaller"
echo " XFCE + XRDP + Audio + Microphone"
echo "========================================="

echo ""
echo "[1/6] Stopping XRDP services..."

sudo systemctl stop xrdp 2>/dev/null || true
sudo systemctl disable xrdp 2>/dev/null || true

echo ""
echo "[2/6] Removing XRDP + XFCE..."

sudo apt purge -y \
  xfce4 \
  xfce4-goodies \
  xrdp \
  xorgxrdp \
  dbus-x11

echo ""
echo "[3/6] Removing Audio + Microphone support..."

sudo apt purge -y \
  pipewire \
  pipewire-pulse \
  wireplumber \
  pipewire-module-xrdp \
  libpipewire-0.3-modules-xrdp \
  pavucontrol \
  xfce4-pulseaudio-plugin

echo ""
echo "[4/6] Removing XFCE session configuration..."

rm -f ~/.xsession
rm -f ~/.xinitrc

echo ""
echo "[5/6] Removing RDP firewall rule..."

sudo ufw delete allow 3389/tcp 2>/dev/null || true

echo ""
echo "[6/6] Cleaning unused packages and configuration..."

sudo apt autoremove --purge -y
sudo apt autoclean -y

echo ""
echo "========================================="
echo " Uninstallation Complete! 🧹"
echo "========================================="
echo ""
echo "Removed:"
echo "  ✓ XFCE Desktop"
echo "  ✓ XRDP"
echo "  ✓ Xorg XRDP"
echo "  ✓ PipeWire"
echo "  ✓ PipeWire Pulse"
echo "  ✓ WirePlumber"
echo "  ✓ XRDP Audio Modules"
echo "  ✓ PulseAudio/PipeWire Controls"
echo "  ✓ XFCE Audio Plugin"
echo "  ✓ XRDP firewall rule"
echo "  ✓ XFCE session configuration"
echo ""
echo "⚠️ Important:"
echo "This script cleans the installed packages and"
echo "configuration created by this installer."
echo ""
echo "It does NOT delete your personal files,"
echo "home directory, documents, or other user data."
echo ""
echo "A reboot is recommended:"
echo ""
echo "sudo reboot"
echo ""
