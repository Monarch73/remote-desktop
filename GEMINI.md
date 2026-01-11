# Project Context: Remote Desktop (Docker + XFCE + XRDP)

## Overview
This project provides a containerized remote desktop environment using Docker. It runs **Ubuntu 24.04** with the **XFCE4** desktop environment and uses **XRDP** to allow remote connections via the standard Remote Desktop Protocol (RDP).

## Key Technologies
*   **Docker & Docker Compose:** Containerization and orchestration.
*   **Ubuntu 24.04 (Noble Numbat):** Base operating system.
*   **XFCE4:** Lightweight desktop environment.
*   **XRDP:** Open-source Remote Desktop Protocol server.
*   **Software:** Google Chrome, Visual Studio Code, and Homebrew.

## Building and Running

### Prerequisites
*   Docker
*   Docker Compose (or `docker compose` plugin)
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

### Customization
You can customize the user credentials by modifying the `args` section in `docker-compose.yml` or passing build arguments:

```yaml
# docker-compose.yml
args:
  USER_NAME: myuser
  USER_PASSWORD: mysecurepassword
  ROOT_PASSWORD: myrootpassword
```

**Important:** If you change `USER_NAME`, you must also update the volume path in `docker-compose.yml`:
```yaml
volumes:
  - home_data:/home/myuser  # Update this to match USER_NAME
```

## Key Files

| File | Description |
| :--- | :--- |
| `Dockerfile` | Defines the image: installs Ubuntu, XFCE, XRDP, Google Chrome, VS Code, Homebrew, creates the user, and configures permissions. |
| `docker-compose.yml` | Orchestrates the container, maps port 3389, sets up the persistent home volume, and passes build arguments. |
| `start.sh` | Entrypoint script. Starts DBus, generates XRDP keys, ensures the user session is configured, and launches the XRDP services. |

## Development Conventions
*   **Persistence:** User data is persisted in the `home_data` Docker volume.
*   **Permissions:** The container creates a non-root user with `sudo` access.
*   **Session Management:** The script automatically ensures `.xsession` exists pointing to `xfce4-session` to ensure the desktop environment loads correctly even on fresh volumes.
