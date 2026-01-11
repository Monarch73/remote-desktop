# Dockerized Remote Desktop (XFCE + XRDP)

A lightweight, containerized Ubuntu desktop environment accessible via the Remote Desktop Protocol (RDP). This project builds a Docker image based on **Ubuntu 24.04**, running the **XFCE4** desktop environment and serving it via **XRDP**.

It is designed to be easy to spin up, persistent, and customizable.

## 🚀 Features

*   **OS:** Ubuntu 24.04 LTS (Noble Numbat)
*   **Desktop:** XFCE4 (Lightweight and fast)
*   **Remote Access:** XRDP (Standard RDP port 3389)
*   **User Management:** Non-root user with `sudo` privileges.
*   **Persistence:** Docker volume for user's home directory (`/home/linuxuser`).
*   **Software:** Google Chrome and Visual Studio Code pre-installed.
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

2.  **Build and Start the container:**
    ```bash
    docker-compose up -d --build
    ```

3.  **Connect via RDP:**
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

### Customizing Credentials

You can change the default username and passwords by modifying the `args` section in `docker-compose.yml` before building:

```yaml
services:
  desktop:
    build:
      args:
        USER_NAME: newuser
        USER_PASSWORD: securepassword
        ROOT_PASSWORD: securerootpassword
    volumes:
      # IMPORTANT: Update this path if you change USER_NAME
      - home_data:/home/newuser
```

*Note: If you change the `USER_NAME`, you must also update the volume mapping path to match the new home directory.*

## 💾 Persistence

This project uses a Docker volume named `home_data` to persist the user's home directory. This means your files and desktop settings in `/home/linuxuser` will survive container restarts and rebuilds.

To reset the data, you can remove the volume:
```bash
docker-compose down -v
```

## 📝 License

[MIT](LICENSE) (or whichever license you choose)
