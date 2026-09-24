# Linux Remote Desktop

<div align="center">

### A safer, repeatable XFCE + XRDP setup for Ubuntu and Debian

[![ShellCheck](https://github.com/nihent/linux-remote-desktop/actions/workflows/ci.yml/badge.svg)](https://github.com/nihent/linux-remote-desktop/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-22c55e?style=flat-square)](LICENSE)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-supported-e95420?style=flat-square&logo=ubuntu&logoColor=white)](https://ubuntu.com/)
[![Debian](https://img.shields.io/badge/Debian-supported-a81d33?style=flat-square&logo=debian&logoColor=white)](https://www.debian.org/)

Turn a headless Linux server into a lightweight graphical desktop that you can access from Windows, macOS, Linux, or mobile RDP clients.

[Quick start](#quick-start) · [Security](#security-first) · [Screenshots](#screenshots) · [Troubleshooting](#troubleshooting)

</div>

> **Scope:** This repository is a setup helper around XFCE, XRDP, and PipeWire. It is not a replacement for the upstream projects and should be tested on a non-critical host before production use.

## Highlights

- Lightweight XFCE desktop environment
- XRDP service for standard RDP clients
- PipeWire, WirePlumber, and XRDP audio integration
- Validation for Ubuntu and Debian hosts
- Installer state tracking and session-file backup
- Conservative uninstall that avoids blanket `autoremove`
- Security-first firewall guidance instead of opening RDP globally

## Quick start

### 1. Download the project

```bash
git clone https://github.com/nihent/linux-remote-desktop.git
cd linux-remote-desktop
```

### 2. Run the installer

The installer asks for `sudo` access, refreshes package indexes, installs the desktop stack, configures the current user's XFCE session, and enables XRDP. It does **not** run a system-wide upgrade or change your firewall automatically.

```bash
chmod +x install.sh uninstall.sh
./install.sh
```

### 3. Secure the RDP port

RDP listens on TCP port `3389`. Restrict it to your own IP address, VPN network, or private cloud security group. For UFW, use a restricted rule similar to:

```bash
sudo ufw allow from YOUR_PUBLIC_IP to any port 3389 proto tcp
```

Do not expose `3389/tcp` to the entire public internet unless you understand and accept the risk. A VPN, SSH tunnel, or provider firewall is preferred.

### 4. Reboot and connect

```bash
sudo reboot
```

Connect to the server's IP address using an RDP client. On Windows, press `Win + R`, enter `mstsc`, and provide the server address. Sign in with an existing Linux user account; do not use the `root` account for graphical sessions.

## What gets installed

| Component | Purpose |
| --- | --- |
| XFCE and XFCE Goodies | Lightweight graphical desktop |
| XRDP and Xorg XRDP | RDP server and Xorg integration |
| PipeWire and WirePlumber | Modern audio session management |
| XRDP audio modules | Audio redirection support where packaged by the distribution |
| Pavucontrol | Graphical audio controls |

Package availability varies by distribution release. If an audio package is unavailable, install the desktop and XRDP components first, then consult your distribution's PipeWire and XRDP documentation.

## Manual installation

If you prefer to review every command, install the core components yourself:

```bash
sudo apt-get update
sudo apt-get install -y \
  xfce4 xfce4-goodies xrdp xorgxrdp dbus-x11
printf '%s\n' 'exec startxfce4' > ~/.xsession
chmod 700 ~/.xsession
sudo systemctl enable --now xrdp
```

Optional audio support:

```bash
sudo apt-get install -y \
  pipewire pipewire-pulse wireplumber \
  pipewire-module-xrdp libpipewire-0.3-modules-xrdp \
  pavucontrol xfce4-pulseaudio-plugin
```

## Uninstallation

The uninstaller is intentionally conservative. It asks for confirmation, stops XRDP, removes only packages recorded as newly installed by the installer, restores a backed-up `.xsession` when available, and does not run `apt autoremove`.

```bash
./uninstall.sh
```

The installer does not manage firewall rules, so remove any custom RDP rule separately when you are ready. Always review the output before confirming removal.

## Security first

- Restrict RDP at the cloud-provider firewall and host firewall.
- Prefer a VPN or private network over a public RDP endpoint.
- Keep Ubuntu/Debian and XRDP packages updated through your normal patch process.
- Use a strong, non-root Linux account and SSH keys for administration.
- Never paste passwords, private keys, or cloud credentials into an issue.
- Review `SECURITY.md` before reporting a vulnerability.

## Troubleshooting

### The XRDP service is not running

```bash
systemctl status xrdp --no-pager
sudo journalctl -u xrdp -b --no-pager
```

### The desktop session is blank or immediately disconnects

Check that the session file contains the XFCE command and that the connecting account has a valid home directory:

```bash
cat ~/.xsession
# expected: exec startxfce4
```

### The client cannot connect

Check the service and listen socket first, then inspect your provider firewall and UFW rules:

```bash
sudo ss -ltnp | grep ':3389'
sudo ufw status verbose
```

Audio and microphone redirection also depends on the RDP client. Enable those options in the client before connecting.

## Screenshots

| XRDP desktop | Terminal |
| --- | --- |
| ![XFCE desktop](Screenshot_20260711_232712.jpg) | ![Terminal](Screenshot_20260717_203907.jpg) |

## Repository layout

```text
.
├── install.sh       # Validated installer with state tracking
├── uninstall.sh     # Confirmation-based conservative cleanup
├── README.md        # Setup, security, and troubleshooting guide
├── SECURITY.md      # Vulnerability reporting guidance
├── CHANGELOG.md     # Release history
└── .github/workflows/ci.yml
```

## Contributing

Bug reports and improvements are welcome. Please include the distribution and release, the exact command that failed, relevant output with secrets removed, and whether the issue occurred during installation, connection, audio, or removal. See [CONTRIBUTING.md](CONTRIBUTING.md) for the contribution process.

## License

This project is released under the [MIT License](LICENSE). XFCE, XRDP, PipeWire, and the other installed components remain under their respective upstream licenses.
