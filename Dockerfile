FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Install XFCE, XRDP and essential tools
RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-goodies \
    xrdp \
    sudo \
    vim \
    net-tools \
    dbus-x11 \
    x11-xserver-utils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Arguments for User and Passwords
ARG USER_NAME=linuxuser
ARG USER_PASSWORD=linuxpassword
ARG ROOT_PASSWORD=rootpassword

# Make the USER_NAME available as an environment variable for the start script
ENV USER_NAME=${USER_NAME}

# Set root password
RUN echo "root:${ROOT_PASSWORD}" | chpasswd

# Create user with sudo privileges
RUN useradd -m -s /bin/bash ${USER_NAME} && \
    echo "${USER_NAME}:${USER_PASSWORD}" | chpasswd && \
    usermod -aG sudo ${USER_NAME}

# Configure XRDP to allow anyone to start X server (needed for some setups)
RUN sed -i 's/allowed_users=console/allowed_users=anybody/' /etc/X11/Xwrapper.config

# Configure XFCE for the user
RUN echo "xfce4-session" > /home/${USER_NAME}/.xsession && \
    chown ${USER_NAME}:${USER_NAME} /home/${USER_NAME}/.xsession

# Grant access to ssl-cert group for xrdp user (often fixes permission issues)
RUN adduser xrdp ssl-cert

# Copy startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose RDP port
EXPOSE 3389

CMD ["/start.sh"]
