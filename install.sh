#!/usr/bin/env bash
set -Eeuo pipefail

readonly STATE_DIR="/var/lib/linux-remote-desktop"
readonly STATE_FILE="${STATE_DIR}/state"
readonly SESSION_FILE="${HOME}/.xsession"
readonly BACKUP_FILE="${STATE_DIR}/xsession.backup"
readonly PACKAGES=(
  xfce4 xfce4-goodies xrdp xorgxrdp dbus-x11
  pipewire pipewire-pulse wireplumber pipewire-module-xrdp
  libpipewire-0.3-modules-xrdp pavucontrol xfce4-pulseaudio-plugin
)

trap 'printf "\nInstallation stopped. Review the output above; no automatic rollback was attempted.\n" >&2' ERR

info() { printf '  %s\n' "$*"; }
fail() { printf '  ERROR: %s\n' "$*" >&2; exit 1; }

command -v sudo >/dev/null 2>&1 || fail "sudo is required."
command -v apt-get >/dev/null 2>&1 || fail "This installer requires apt-get."
sudo -v || fail "Could not obtain sudo access."

if [[ -r /etc/os-release ]]; then
  # shellcheck disable=SC1091
  source /etc/os-release
else
  fail "Cannot identify the operating system."
fi
case "${ID:-}" in
  ubuntu|debian) ;;
  *) fail "Supported systems are Ubuntu and Debian; detected ${PRETTY_NAME:-unknown}." ;;
esac

printf '\n%s\n' '╭──────────────────────────────────────────────╮'
printf '%s\n' '│       Linux Remote Desktop Installer          │'
printf '%s\n' '│       XFCE • XRDP • PipeWire Audio            │'
printf '%s\n\n' '╰──────────────────────────────────────────────╯'
info "Detected: ${PRETTY_NAME:-$ID}"
info "No system-wide upgrade will be performed."
info "The firewall is not changed automatically."
printf '\n'

if [[ -e "$SESSION_FILE" ]]; then
  sudo install -d -m 0755 "$STATE_DIR"
  sudo cp -a "$SESSION_FILE" "$BACKUP_FILE"
  info "Backed up existing ${SESSION_FILE} to ${BACKUP_FILE}."
fi

sudo install -d -m 0755 "$STATE_DIR"
sudo truncate -s 0 "${STATE_DIR}/new-packages"
for package in "${PACKAGES[@]}"; do
  if ! dpkg-query -W -f='${Status}' "$package" 2>/dev/null | grep -q 'install ok installed'; then
    printf '%s\n' "$package" | sudo tee -a "${STATE_DIR}/new-packages" >/dev/null
  fi
done

info "Refreshing package indexes..."
sudo apt-get update
info "Installing XFCE, XRDP, and audio support..."
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "${PACKAGES[@]}"

printf '%s\n' 'exec startxfce4' > "$SESSION_FILE"
chmod 700 "$SESSION_FILE"

info "Enabling XRDP..."
sudo systemctl enable --now xrdp

sudo tee "$STATE_FILE" >/dev/null <<EOF
installed_by_linux_remote_desktop=1
session_file=$SESSION_FILE
created_at=$(date -u +%Y-%m-%dT%H:%M:%SZ)
EOF

printf '\n%s\n' 'Installation complete.'
printf '%s\n' 'Next steps:'
printf '%s\n' '  1. Restrict TCP/3389 to your own IP or VPN in your provider firewall.'
printf '%s\n' '  2. If UFW is enabled, add a restricted rule, for example:'
printf '%s\n' '     sudo ufw allow from YOUR_PUBLIC_IP to any port 3389 proto tcp'
printf '%s\n' '  3. Reboot the server, then connect with an RDP client.'
printf '%s\n\n' '  4. Run ./uninstall.sh only when you want to remove this setup.'
