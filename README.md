# Dockerized Remote Desktop (XFCE / MATE / KDE Plasma + XRDP)

A lightweight, containerized Ubuntu desktop environment accessible via the Remote Desktop Protocol (RDP). This project builds a Docker image based on **Ubuntu 26.04**, supporting **XFCE4**, **MATE**, or **KDE Plasma** desktop environments served via **XRDP**.

It is designed to be easy to spin up, persistent, customizable, and GPU-pass-through ready.

## 🚀 Features

*   **OS:** Ubuntu 26.04 (Resolute Raccoon)
*   **Desktop Options:** XFCE4 (Lightweight), MATE (Full), KDE Plasma (Full)
*   **Remote Access:** XRDP (Standard RDP port 3389)
*   **GPU Acceleration:** Commented configuration options for NVIDIA Container Toolkit and WSL2 `/dev/dxg` DirectX pass-through.
*   **Security:** AppArmor & Seccomp unconfined options for seamless DBus and sandbox compatibility.
*   **User Management:** Non-root user with `sudo` privileges.
*   **Persistence:** Docker volume for user's home directory (`/home/linuxuser`).
*   **Software:** Google Chrome, Microsoft Edge, and Visual Studio Code pre-installed.
*   **Tools:** Includes basic tools like `vim`, `net-tools`, `sudo`, and `Homebrew`.

## 📋 Prerequisites

*   [Docker Engine](https://docs.docker.com/get-docker/)
*   [Docker Compose](https://docs.docker.com/compose/install/)
*   An RDP Client (e.g., Microsoft Remote Desktop, Remmina, xfreerdp)

## 🛠️ Quick Start

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/your-username/your-repo-name.git
    cd your-repo-name
    ```

2.  **Select Desktop Environment (Optional):**
    In `docker-compose.yml`, uncomment your preferred Dockerfile under `build:`:
    ```yaml
    dockerfile: Dockerfile       # XFCE4 (Default)
    # dockerfile: Dockerfile.mate  # MATE
    # dockerfile: Dockerfile.kde   # KDE Plasma
    ```

3.  **Build and Start the container:**
    ```bash
    docker-compose up -d --build
    ```

4.  **Connect via RDP:**
    Open your RDP client and connect to:
    *   **Address:** `localhost:3389`
    *   **Username:** `linuxuser`
    *   **Password:** `linuxpassword`

## ⚙️ Configuration

### Default Credentials

| Account | Username | Password |
| :--- | :--- | :--- |
| **User** | `linuxuser` | `linuxpassword` |
| **Root** | `root` | `rootpassword` |

### GPU Pass-Through Setup

`docker-compose.yml` includes commented sections for GPU acceleration:

- **NVIDIA GPU (Host with NVIDIA Container Toolkit)**:
  Uncomment the `deploy.resources.reservations.devices` section in `docker-compose.yml`.
- **WSL2 / DirectX GPU (Windows Host)**:
  Uncomment the `devices: - /dev/dxg:/dev/dxg` and `MESA_D3D12_DEFAULT_ADAPTER=1` section in `docker-compose.yml`.

## 💾 Persistence

This project uses a Docker volume named `home_data` to persist the user's home directory (`/home/linuxuser`).

### 🌱 Automatic Home Seeding
When starting a container with a fresh or empty volume/bind mount at `/home/linuxuser`, the container checks for the presence of the `Desktop` directory (`/home/linuxuser/Desktop`). If missing, it automatically extracts a pre-packaged, highly compressed seed archive (`/opt/home_seed.tar.xz`) to seed default environment files (`.xsession`, `.bashrc`, Homebrew, and desktop settings). If `Desktop` already exists, seeding is skipped to protect existing user data.

To reset the data and trigger re-seeding:
```bash
docker-compose down -v
```

## 📝 License

[MIT](LICENSE)
