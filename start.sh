#!/bin/bash

# Ensure DBus machine-id exists
dbus-uuidgen --ensure=/etc/machine-id 2>/dev/null || true

# Start DBus (often required for desktop environments)
service dbus start

# Generate keys if they don't exist (xrdp-keygen)
if [ ! -f /etc/xrdp/rsakeys.ini ]; then
    xrdp-keygen xrdp auto
fi

# Seed home directory from compressed archive if Desktop folder does NOT exist
if [ -f /opt/home_seed.tar.xz ] && [ ! -d "/home/$USER_NAME/Desktop" ]; then
    echo "Seeding home directory for $USER_NAME from /opt/home_seed.tar.xz..."
    mkdir -p /home/$USER_NAME
    tar -xf /opt/home_seed.tar.xz -C /home/$USER_NAME/
    chown -R $USER_NAME:$USER_NAME /home/$USER_NAME
    echo "Home directory seeded for $USER_NAME."
else
    echo "Home directory not seeded for $USER_NAME."
fi

# Make sure the user has a .xsession file if not present (in case volume was empty)
if [ ! -f /home/$USER_NAME/.xsession ]; then
    if command -v mate-session >/dev/null 2>&1; then
        echo "mate-session" > /home/$USER_NAME/.xsession
    elif command -v startplasma-x11 >/dev/null 2>&1; then
        echo "startplasma-x11" > /home/$USER_NAME/.xsession
    else
        echo "xfce4-session" > /home/$USER_NAME/.xsession
    fi
    chown $USER_NAME:$USER_NAME /home/$USER_NAME/.xsession
fi

# Ensure Homebrew is in .bashrc (in case volume persisted an old .bashrc)
if [ -f /home/$USER_NAME/.bashrc ] && ! grep -q "brew shellenv" /home/$USER_NAME/.bashrc; then
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/$USER_NAME/.bashrc
    chown $USER_NAME:$USER_NAME /home/$USER_NAME/.bashrc
fi

# Ensure PowerShell profile exists and is configured (in case volume persisted an older home directory)
PS_PROFILE_DIR="/home/$USER_NAME/.config/powershell"
PS_PROFILE_PATH="$PS_PROFILE_DIR/Microsoft.PowerShell_profile.ps1"
if [ ! -f "$PS_PROFILE_PATH" ]; then
    mkdir -p "$PS_PROFILE_DIR"
    printf 'if (Test-Path "/home/linuxbrew/.linuxbrew/bin/brew") {\n    (& "/home/linuxbrew/.linuxbrew/bin/brew" shellenv) | Invoke-Expression\n}\n\nif (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {\n    oh-my-posh init pwsh --config "/usr/local/share/oh-my-posh/themes/jandedobbeleer.omp.json" | Invoke-Expression\n}\n' > "$PS_PROFILE_PATH"
    chown -R $USER_NAME:$USER_NAME "$PS_PROFILE_DIR"
fi

# Clean up stale PID and lock files from previous container runs
rm -f /var/run/xrdp.pid /var/run/xrdp-sesman.pid /var/run/xrdp/xrdp*.pid 2>/dev/null || true

# Start sesman in background
/usr/sbin/xrdp-sesman

# Start xrdp in foreground
/usr/sbin/xrdp --nodaemon

