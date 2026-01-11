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
    build-essential \
    curl \
    git \
    file \
    procps \
    gnupg \
    apt-transport-https \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Google Chrome and Visual Studio Code
RUN curl -fsSL https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome-archive-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list && \
    curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /usr/share/keyrings/packages.microsoft.gpg && \
    install -D -o root -g root -m 644 /usr/share/keyrings/packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg && \
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list && \
    apt-get update && apt-get install -y \
    google-chrome-stable \
    htop \
    netcat-openbsd \
    telnet \
    sshfs \
    socat \
    screen\
    code \
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

# Install Homebrew
# Create the linuxbrew directory and give ownership to the user
RUN mkdir -p /home/linuxbrew/.linuxbrew && \
    chown -R ${USER_NAME}:${USER_NAME} /home/linuxbrew

# Switch to the user context to install Homebrew
USER ${USER_NAME}
ENV NONINTERACTIVE=1
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Configure environment for the user
RUN echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/${USER_NAME}/.bashrc

# Add Homebrew to PATH for the rest of the build (if needed) and runtime
ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"

# Switch back to root for the remaining operations (start.sh needs root)
USER root

# Grant access to ssl-cert group for xrdp user (often fixes permission issues)
RUN adduser xrdp ssl-cert

# Copy startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose RDP port
EXPOSE 3389

CMD ["/start.sh"]
