# Project Context: Remote Desktop (Docker + Desktop Environment + XRDP)

## Overview
This project provides a containerized remote desktop environment using Docker. It runs **Ubuntu 26.04** with customizable desktop environments (**XFCE4**, **MATE**, or **KDE Plasma**) and uses **XRDP** to allow remote connections via standard Remote Desktop Protocol (RDP).

## Key Technologies
*   **Docker & Docker Compose:** Containerization and orchestration.
*   **Ubuntu 26.04 (Resolute Raccoon):** Base operating system.
*   **Desktop Environments:** Choice of XFCE4, MATE, or KDE Plasma.
*   **XRDP:** Open-source Remote Desktop Protocol server.
*   **Software:** Google Chrome, Visual Studio Code, and Homebrew.
*   **GPU Pass-Through:** Configurable NVIDIA & WSL2/DirectX hardware acceleration options.

## Building and Running

### Prerequisites
*   Docker & Docker Compose
*   An RDP Client (e.g., Microsoft Remote Desktop, Remmina)

### Quick Start
1.  **Build and Start:**
    ```bash
    docker-compose up -d --build
    ```
2.  **Connect:**
    *   Open your RDP client.
    *   Connect to `localhost:3389`.
    *   **Username:** `linuxuser`
    *   **Password:** `linuxpassword`
    *   *(Note: Root password is `rootpassword`)*

### Desktop Environment Selection
In `docker-compose.yml`, uncomment your desired desktop environment Dockerfile under `build:`:

```yaml
build:
  context: .
  dockerfile: Dockerfile       # XFCE4 (Lightweight - Default)
  # dockerfile: Dockerfile.mate  # MATE (Full Desktop)
  # dockerfile: Dockerfile.kde   # KDE Plasma (Full Desktop)
```

### GPU Pass-Through Options
`docker-compose.yml` includes commented configurations for:
- **NVIDIA GPU Pass-Through**: Via NVIDIA Container Toolkit (`deploy.resources.reservations.devices`).
- **WSL2 / DirectX GPU Pass-Through**: Via `/dev/dxg` device mapping on Windows.

## Key Files

| File | Description |
| :--- | :--- |
| `Dockerfile` | Defines the XFCE4 desktop environment image. |
| `Dockerfile.mate` | Defines the MATE desktop environment image (full package). |
| `Dockerfile.kde` | Defines the KDE Plasma desktop environment image (full package). |
| `docker-compose.yml` | Orchestrates the container, RDP port 3389, volume mappings, AppArmor, and commented GPU options. |
| `start.sh` | Entrypoint script. Ensures DBus machine-id, extracts home seed archive if `~/Desktop` is missing, cleans stale lock files, and launches XRDP. |

## Development Conventions
*   **Persistence:** User data is persisted in the `home_data` Docker volume.
*   **Permissions:** Non-root user with `sudo` access and `ssl-cert` membership.
*   **Session Management:** Dynamic `.xsession` generation auto-detects installed session binary (`xfce4-session`, `mate-session`, or `startplasma-x11`).
*   **Home Directory Seeding:** During image build, `/home/$USER_NAME` is packed into `/opt/home_seed.tar.xz`. On startup, if `/home/$USER_NAME/Desktop` is missing, `start.sh` automatically unpacks the archive into the home directory.
