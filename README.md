<div align="center">

# 🖥️ XFCE + XRDP Remote Desktop Setup

### ⚡ Turn your Ubuntu/Debian Server into a Full Remote Desktop in Minutes

<img src="https://img.shields.io/badge/Linux-Ubuntu%20%7C%20Debian-E95420?style=for-the-badge&logo=linux&logoColor=white">
<img src="https://img.shields.io/badge/Desktop-XFCE-2284F2?style=for-the-badge&logo=xfce&logoColor=white">
<img src="https://img.shields.io/badge/Remote-XRDP-2D9CDB?style=for-the-badge">
<img src="https://img.shields.io/badge/License-MIT-success?style=for-the-badge">

<br>

*A beautiful and lightweight Remote Desktop environment for your VPS or Dedicated Server.*

⭐ If this project helps you, consider giving it a **Star**.

</div>

---

## 📖 Overview

This repository provides an easy way to install:

- 🖥️ XFCE Desktop Environment
- 🌐 XRDP Remote Desktop
- ⚡ Lightweight & Fast
- 🔒 Secure Remote Login
- 🚀 Beginner Friendly

---

# 📦 Installation

## ① Update System

```bash
sudo apt update && sudo apt upgrade -y
```

---

## ② Install XFCE + XRDP

```bash
sudo apt install -y xfce4 xfce4-goodies xrdp dbus-x11
```

---

## ③ Configure XFCE Session

```bash
echo "xfce4-session" > ~/.xsession
```

---

## ④ Enable XRDP

```bash
sudo systemctl enable --now xrdp
```

---

## ⑤ Allow Firewall Port

```bash
sudo ufw allow 3389/tcp
```

---

## ⑥ Reboot (Recommended)

```bash
sudo reboot
```

---

# 🖥️ Connect Using Remote Desktop

### Windows

Open Run (`Win + R`)

```text
mstsc
```

Enter your server IP.

Login using:

- Username
- Password

Done! 🎉

---

# 📂 Installed Packages

| Package | Description |
|----------|-------------|
| 🖥️ xfce4 | XFCE Desktop |
| 🎨 xfce4-goodies | Extra XFCE Applications |
| 🌐 xrdp | Remote Desktop Server |
| ⚙️ dbus-x11 | Desktop Session Support |

---

# ⚙️ Useful Commands

### Check XRDP Status

```bash
systemctl status xrdp
```

### Restart XRDP

```bash
sudo systemctl restart xrdp
```

### Stop XRDP

```bash
sudo systemctl stop xrdp
```

### Disable XRDP

```bash
sudo systemctl disable xrdp
```

---

# 🗑️ Uninstall

```bash
sudo apt remove --purge xfce4 xfce4-goodies xrdp dbus-x11 -y
sudo apt autoremove -y
```

---

# 📋 Requirements

✅ Ubuntu/Debian

✅ Root or sudo access

✅ Internet Connection

---

# 💡 Why XFCE?

| Feature | Benefit |
|---------|---------|
| ⚡ Lightweight | Low RAM Usage |
| 🚀 Fast | Great Performance |
| 🛠️ Stable | Reliable Desktop |
| 🎯 Beginner Friendly | Easy to Use |

---

# 🤝 Contributing

Contributions, Issues and Pull Requests are always welcome!

Feel free to improve this repository.

---

# ⭐ Support

If this project helped you,

<div align="center">

## ⭐ Star this Repository ⭐

It motivates future updates and helps more people discover the project.

</div>

---

<div align="center">

### ❤️ Made for the Linux Community

**Happy Remote Computing! 🚀**

</div>
