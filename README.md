# Docker Remote Desktop Container — Ubuntu 26.04 Desktop Environment (XRDP, GPU Acceleration, XFCE, KDE Plasma, MATE, PowerShell 7)

[![Ubuntu](https://img.shields.io/badge/Ubuntu-26.04%20Resolute%20Raccoon-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)](https://ubuntu.com)
[![Docker](https://img.shields.io/badge/Docker%20Desktop-Ready-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com)
[![RDP](https://img.shields.io/badge/XRDP%20Server-Port%203389-0078D4?style=for-the-badge&logo=remotedesktop&logoColor=white)](http://xrdp.org)
[![PowerShell](https://img.shields.io/badge/PowerShell-7.x%20Default%20Shell-5391FE?style=for-the-badge&logo=powershell&logoColor=white)](https://github.com/PowerShell/PowerShell)
[![Oh My Posh](https://img.shields.io/badge/Oh%20My%20Posh-Flagship%20Theme-FF6C37?style=for-the-badge)](https://ohmyposh.dev)
[![GPU Acceleration](https://img.shields.io/badge/GPU%20Passthrough-NVIDIA%20%2F%20WSL2%20DirectX-76B900?style=for-the-badge&logo=nvidia&logoColor=white)](#-gpu-pass-through-setup)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)

A high-performance, persistent, and containerized **Ubuntu 26.04 (Resolute Raccoon) Remote Desktop Docker workspace** accessible via standard **Remote Desktop Protocol (XRDP)**. 

Engineered for modern developer workflows, DevOps engineers, cloud bastion jump boxes, and AI/ML workstations, this project delivers a fully interactive Linux GUI directly inside Docker. It combines multi-desktop environment options (**XFCE4, KDE Plasma 6, MATE**), out-of-the-box **NVIDIA & Windows WSL2 DirectX 3D hardware acceleration**, a cutting-edge terminal stack powered by **PowerShell 7, Oh My Posh, and JetBrainsMono Nerd Font**, and pre-configured **GUI sandboxing for Google Chrome, Microsoft Edge, and Visual Studio Code**.

---

## 🌟 Why This Remote Desktop Container? (Key Features)

### 🖥️ 1. Multi-Desktop Environment Agility
Switch between lightweight performance and feature-rich full-desktop experiences simply by changing a comment in your configuration:
*   **XFCE4 Desktop (Default):** Ultra-lightweight, blazing-fast, and minimal RAM footprint—ideal for low-latency RDP connections and cloud VMs.
*   **KDE Plasma Desktop:** A luxurious, visually rich full desktop suite with custom Konsole terminal integration and dynamic visual frameworks.
*   **MATE Desktop:** A robust, traditional, and stable full desktop workstation experience powered by customizable GNOME 2 architecture and dconf state management.

### ⚡ 2. Modern Linux Terminal & Shell Stack
Say goodbye to basic bash prompts. This container is architected from the ground up to deliver a world-class terminal interface:
*   **PowerShell 7 (`pwsh`):** Configured as the global default user login shell across all desktop environments and terminal emulators. Installed robustly via official standalone GitHub Linux-x64 release binary archives.
*   **Oh My Posh Flagship Prompt:** Integrated directly into `$PROFILE.CurrentUserAllHosts` featuring the standard flagship theme (`jandedobbeleer.omp.json`) for zero-latency, offline Git and system telemetry rendering.
*   **JetBrainsMono Nerd Font:** Built-in fontconfig rules (`/etc/fonts/conf.d/01-nerdfont.conf`) assign JetBrainsMono Nerd Font Mono as the premier monospace system font.
*   **Multi-Layer UTF-8 Encoding:** Comprehensive character set unification across system locales (`en_US.UTF-8`), terminal profiles (`terminalrc`, `dconf`, and Konsole `Default.profile`), and PowerShell stream encoders (`$OutputEncoding`), ensuring glyphs, Powerline arrows, and icons never break or turn into empty font boxes ("tofu").

### 🎮 3. 3D Hardware Accelerated GPU Passthrough
Don't settle for sluggish software rendering. Unlock high-frame-rate 3D desktop performance, OpenGL modeling, CAD, and AI acceleration directly inside your container:
*   **NVIDIA Container Toolkit:** Native host GPU device translation for Linux and supported Docker runtime servers.
*   **Windows WSL2 / DirectX 12 (`/dev/dxg`):** Direct hardware acceleration mapping on Windows 10/11 hosts utilizing Mesa DirectX 12 display adapters (`MESA_D3D12_DEFAULT_ADAPTER=1`), enabling smooth rendering across NVIDIA, AMD, and Intel GPUs.

### 🛡️ 4. Resolved Chromium Container Sandboxing
Running GUI web browsers inside non-privileged Docker containers frequently causes namespace crashes (`Failed to move to new namespace` or `Operation not permitted (1)`). This workspace solves container sandbox limits out of the box:
*   **Kernel Namespace Privileges:** Utilizes standard Docker unconfined seccomp, AppArmor, and `SYS_ADMIN` capability profiling.
*   **Automated Desktop Wrappers:** Includes pre-installed **Google Chrome**, **Microsoft Edge**, and **Visual Studio Code (`code`)**. Every system launcher menu item (`/usr/share/applications/*.desktop`) and execution wrapper script (`/usr/local/bin/`) is automatically patched to inject Docker-safe memory and sandbox directives (`--no-sandbox --disable-dev-shm-usage`). Whether clicked via GUI menu or launched from terminal, applications run smoothly without shared memory exhaustion or Zygote assertions.

### 💾 5. Automatic Persistence & Home Seeding
Your development workspace, installed extensions, SSH keys, and desktop customizations survive across container rebuilds:
*   **Persistent Docker Volumes:** All userdata is safely stored within the `home_data` volume attached to `/home/linuxuser`.
*   **Intelligent Seeding Archive (`start.sh`):** Upon booting with a clean volume, an automated entrypoint script extracts a compressed base configuration archive (`/opt/home_seed.tar.xz`), seeding clean desktop icons, `.xsession` files, **Homebrew** package managers, and PowerShell profiles without overwriting existing data on subsequent runs.

---

## 📋 Prerequisites & Compatibility

*   **Docker Engine:** Version 20.10+ ([Install Docker](https://docs.docker.com/get-docker/))
*   **Docker Compose:** V2 or standalone V1 ([Install Compose](https://docs.docker.com/compose/install/))
*   **RDP Client:**
    *   **Windows:** Built-in Remote Desktop Connection (`mstsc.exe`) or Windows App.
    *   **macOS / iOS / Android:** Microsoft Remote Desktop Application.
    *   **Linux:** Remmina, `xfreerdp`, or Vinagre.

---

## 🛠️ Quick Start Guide

### 1. Clone the Repository
```bash
git clone https://github.com/your-username/remote-desktop.git
cd remote-desktop
```

### 2. Select Your Preferred Desktop Environment
Open `docker-compose.yml` and uncomment your desired build target under the `desktop` service:
```yaml
build:
  context: .
  dockerfile: Dockerfile       # XFCE4 Lightweight Desktop (Default)
  # dockerfile: Dockerfile.mate  # MATE Full Desktop Workstation
  # dockerfile: Dockerfile.kde   # KDE Plasma Full Desktop Workstation
```

### 3. Build & Launch the Container
Start the background daemon and generate your persistent workstation image:
```bash
docker-compose up -d --build
```

### 4. Connect via Remote Desktop Protocol
Launch your preferred RDP client and dial into the workspace:
*   **Host / Socket Address:** `localhost:3389`
*   **Login Username:** `linuxuser`
*   **Account Password:** `linuxpassword`

---

## ⚙️ Authentication & Credentials Reference

The container instantiates a secure, sudo-capable standard user account alongside standard system superuser access. You can customize these defaults directly within the build arguments of `docker-compose.yml`:

| Account Type | Default Username | Default Password | Sudo Entitlements |
| :--- | :--- | :--- | :--- |
| **Standard Worker** | `linuxuser` | `linuxpassword` | Unrestricted (`sudo -i`, `ALL=(ALL:ALL) NOPASSWD/PASSWD`) |
| **System Root** | `root` | `rootpassword` | Full root access |

---

## 🏎️ GPU Pass-Through Setup Guide

To harness GPU hardware acceleration for rendering graphics, web browser hardware decoders, or AI workloads, uncomment the matching section inside your `docker-compose.yml`:

### Option A: Windows Host via WSL2 / DirectX Passthrough
Ideal for Docker Desktop users running Windows 10 or Windows 11 with Intel, AMD, or NVIDIA graphic cards:
```yaml
    # Uncomment in docker-compose.yml:
    devices:
      - /dev/dxg:/dev/dxg
    environment:
      - LIBGL_ALWAYS_SOFTWARE=0
      - MESA_D3D12_DEFAULT_ADAPTER=1
```
*Note: Requires up-to-date Windows GPU drivers with WSL2 support.*

### Option B: Linux Host with NVIDIA Container Toolkit
Ideal for dedicated server host nodes containing NVIDIA RTX / Quadro / Data Center GPUs:
```yaml
    # Uncomment in docker-compose.yml:
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]
```
*Note: Requires the host operating system to run the [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html).*

---

## 🏢 Common Use Cases & Industry Applications

*   **Cloud Bastion & Remote Jump Box:** Securely inspect network firewalls, SSH endpoints, internal enterprise web apps, or Kubernetes clusters from an isolated, fully persistent containerized desktop workstation.
*   **Automated Browser Testing & GUI QA:** Run Selenium, Puppeteer, Playwright, or Cypress integration suites against fully graphic, non-headless Chromium instances (Edge and Chrome) with zero sandbox overhead or crashes.
*   **Isolated Web Browsing & Sandbox Research:** Safely open unfamiliar attachments, examine untrusted URLs, or perform malware analysis inside an unprivileged, ephemeral containerized OS that can be reset in seconds via `docker-compose down -v`.
*   **Portable AI / Development Workstation:** Provision instantaneous, consistent Linux development environments complete with Visual Studio Code (`code`), Homebrew, Git, and PowerShell 7 across onboarding development teams regardless of host operating systems (macOS, Windows, Linux).

---

## ❓ Frequently Asked Questions (FAQ) & Troubleshooting

### How do I fix Microsoft Edge or Google Chrome crashing with "Failed to move to new namespace" in Docker?
This repository resolves this issue automatically! Chromium rendering engines rely on unprivileged user namespace cloning (`CLONE_NEWUSER`), which standard container runtimes reject by default. Our architecture grants `SYS_ADMIN` capability profiles within `docker-compose.yml` and wraps all desktop GUI menu shortcuts and command-line execution binaries (`/usr/local/bin/google-chrome`, `/usr/local/bin/microsoft-edge`) with automatic `--no-sandbox --disable-dev-shm-usage` flags to ensure rock-solid rendering without manual intervention.

### Why do Nerd Font symbols, Git branches, or Oh My Posh glyphs show as squares or question marks?
If fonts render incorrectly in standard Linux containers, it is almost always due to an underlying POSIX/ASCII locale default or stream misconfiguration. We eliminate this by generating complete `en_US.UTF-8` system locales, injecting forced UTF-8 parameters into terminal engine preference files (`terminalrc`, `dconf`, Konsole profile), and overriding PowerShell console stream encoders (`$OutputEncoding = [System.Text.Encoding]::UTF8`). If using a remote viewer on Windows, ensure your remote monitor resolution and client settings allow standard bitmap caching.

### How do I reset my user directory and trigger a fresh seed of the default profile?
To wipe all customizations, browser histories, and local cache, shut down the environment and delete the persistent Docker volume:
```bash
docker-compose down -v
docker-compose up -d
```
Upon restarting, `start.sh` detects an empty `/home/linuxuser` directory and automatically extracts `/opt/home_seed.tar.xz` to restore pristine factory settings.

### How do I install additional CLI software or development packages?
Your terminal includes both Debian APT package manager access via `sudo apt-get install <package>` and standard Linux **Homebrew** access (`brew install <formula>`), which comes seeded directly inside your PowerShell path profile.

---

## 📝 License & Contributing

This project is open-source and released under the [MIT License](LICENSE). Contributions, bug reports, feature enhancements, and desktop profile optimizations are actively welcomed via GitHub Pull Requests!

---
*Keywords & Topics: docker desktop environment, ubuntu remote desktop container, xrdp docker server, linux gui container, wsl2 directx gpu passthrough docker, nvidia container toolkit remote desktop, powershell linux container, oh my posh terminal docker, xfce4 docker rdp, kde plasma docker rdp, mate desktop container, run chrome edge inside docker GUI.*
