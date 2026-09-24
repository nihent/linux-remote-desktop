#!/usr/bin/env bash
set -Eeuo pipefail

readonly STATE_DIR="/var/lib/linux-remote-desktop"
readonly STATE_FILE="${STATE_DIR}/state"
readonly PACKAGE_FILE="${STATE_DIR}/new-packages"
readonly SESSION_FILE="${HOME}/.xsession"
readonly BACKUP_FILE="${STATE_DIR}/xsession.backup"

info() { printf '  %s\n' "$*"; }
fail() { printf '  ERROR: %s\n' "$*" >&2; exit 1; }

command -v sudo >/dev/null 2>&1 || fail "sudo is required."
sudo -v || fail "Could not obtain sudo access."

printf '\n%s\n' '╭──────────────────────────────────────────────╮'
printf '%s\n' '│       Linux Remote Desktop Uninstaller        │'
printf '%s\n' '│       Conservative cleanup • No autoremove    │'
printf '%s\n\n' '╰──────────────────────────────────────────────╯'

if [[ ! -f "$STATE_FILE" ]]; then
  info "No installer state was found. Nothing will be removed."
  exit 0
fi

read -r -p "Remove the Linux Remote Desktop setup? [y/N] " answer
[[ "$answer" =~ ^[Yy]$ ]] || { info "Cancelled. No changes were made."; exit 0; }

info "Stopping XRDP..."
sudo systemctl disable --now xrdp 2>/dev/null || true

if [[ -s "$PACKAGE_FILE" ]]; then
  info "Removing only packages recorded as newly installed..."
  mapfile -t packages < "$PACKAGE_FILE"
  if ((${#packages[@]})); then
    sudo apt-get purge -y "${packages[@]}" || true
  fi
else
  info "No package list found; leaving packages installed for safety."
fi

if [[ -f "$BACKUP_FILE" ]]; then
  cp -a "$BACKUP_FILE" "$SESSION_FILE"
  info "Restored the previous ${SESSION_FILE}."
elif [[ -f "$SESSION_FILE" ]] && grep -qx 'exec startxfce4' "$SESSION_FILE"; then
  rm -f "$SESSION_FILE"
  info "Removed the session file created by this installer."
else
  info "Preserved ${SESSION_FILE}; it may not belong to this project."
fi

info "Removing the installer state directory..."
sudo rm -rf "$STATE_DIR"

printf '\n%s\n' 'Uninstallation complete.'
printf '%s\n' 'No firewall rules were changed and no apt autoremove was run.'
printf '%s\n\n' 'If you created a custom RDP firewall rule, remove it manually when ready.'
