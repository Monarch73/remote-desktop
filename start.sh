#!/bin/bash

# Start DBus (often required for desktop environments)
service dbus start

# Generate keys if they don't exist (xrdp-keygen)
if [ ! -f /etc/xrdp/rsakeys.ini ]; then
    xrdp-keygen xrdp auto
fi

# Make sure the user has a .xsession file if not present (in case volume was empty)
if [ ! -f /home/$USER_NAME/.xsession ]; then
    echo "xfce4-session" > /home/$USER_NAME/.xsession
    chown $USER_NAME:$USER_NAME /home/$USER_NAME/.xsession
fi

# Ensure Homebrew is in .bashrc (in case volume persisted an old .bashrc)
if [ -f /home/$USER_NAME/.bashrc ] && ! grep -q "brew shellenv" /home/$USER_NAME/.bashrc; then
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/$USER_NAME/.bashrc
    chown $USER_NAME:$USER_NAME /home/$USER_NAME/.bashrc
fi

# Start sesman in background
/usr/sbin/xrdp-sesman

# Start xrdp in foreground
/usr/sbin/xrdp --nodaemon
