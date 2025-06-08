#!/bin/sh

# Check if already initialized
if [ -f /home/developer/.initialized ]; then
    echo "Environment already initialized, starting services..."
else
    echo "First run - installing packages..."
    
    # Install all packages
    apk add --no-cache \
        openssh \
        tmux \
        fish \
        neovim \
        ripgrep \
        github-cli \
        curl \
        git \
        bash \
        sudo \
        shadow \
        starship \
        nodejs \
        npm \
        python3 \
        py3-pip \
        chromium \
        chromium-chromedriver \
        xvfb \
        dbus \
        ttf-freefont \
        font-noto-emoji \
        wqy-zenhei \
        build-base \
        gcc \
        musl-dev \
        libffi-dev \
        python3-dev \
        jq \
        yq \
        fzf \
        bat \
        exa \
        fd \
        httpie \
        tree \
        htop \
        ncdu \
        entr \
        direnv \
        make \
        cmake \
        go \
        rust \
        docker \
        docker-compose \
        wget \
        unzip \
        zip \
        less \
        which \
        file \
        strace \
        lsof \
        procps \
        coreutils \
        findutils \
        util-linux

    # Install Python packages for AI/Claude
    pip3 install \
        playwright \
        requests \
        beautifulsoup4 \
        pandas \
        numpy \
        flask \
        fastapi \
        uvicorn \
        pytest \
        black \
        flake8 \
        mypy \
        jupyter \
        ipython
    
    # Configure SSH
    ssh-keygen -A
    sed -i 's/#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
    sed -i 's/#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
    sed -i 's/#PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
    echo "AllowUsers developer" >> /etc/ssh/sshd_config
    
    # Force SSH to exec tmux for developer user
    echo "Match User developer" >> /etc/ssh/sshd_config
    echo "    ForceCommand /usr/bin/tmux attach -t main || /usr/bin/tmux new -s main" >> /etc/ssh/sshd_config
    
    # Create developer user
    adduser -D -s /bin/fish developer
    echo "developer:developer" | chpasswd
    adduser developer wheel
    echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
    
    # Create directories
    mkdir -p /home/developer/.ssh /home/developer/.config/fish /home/developer/.config/nvim
    
    # Configure starship
    echo "starship init fish | source" >> /home/developer/.config/fish/config.fish
    
    # Configure direnv
    echo 'direnv hook fish | source' >> /home/developer/.config/fish/config.fish
    
    # Set up aliases
    cat >> /home/developer/.config/fish/config.fish << 'EOF'
alias ll='exa -la'
alias ls='exa'
alias cat='bat'
alias find='fd'
alias vim='nvim'
alias grep='rg'
alias top='htop'
alias ps='ps aux'
alias df='df -h'
alias du='ncdu'
alias json='jq'
alias yaml='yq'
alias http='http --print=HhBb'
alias curl='curl -v'
EOF
    
    # Set proper ownership
    chown -R developer:developer /home/developer
    chmod 700 /home/developer/.ssh
    
    # Mark as initialized
    su - developer -c "touch /home/developer/.initialized"
    
    # Install Playwright browsers as developer user
    su - developer -c "playwright install chromium firefox webkit && playwright install-deps"
fi

# Start SSH service
mkdir -p /run/sshd
/usr/sbin/sshd

# Start display server for Playwright
if [ "$ENABLE_DISPLAY" = "true" ]; then
    Xvfb :99 -screen 0 1920x1080x24 -nolisten tcp &
    export DISPLAY=:99
fi

# Set up SSH keys if provided
if [ -f /home/developer/workspace/.ssh/authorized_keys ]; then
    cp /home/developer/workspace/.ssh/authorized_keys /home/developer/.ssh/
    chmod 600 /home/developer/.ssh/authorized_keys
    chown developer:developer /home/developer/.ssh/authorized_keys
fi

# Copy tmux config and create initial session
cp /home/developer/workspace/.tmux.conf /home/developer/.tmux.conf 2>/dev/null || true
chown developer:developer /home/developer/.tmux.conf 2>/dev/null || true

# Create initial tmux session with OpenCode-like layout
su - developer -c "tmux new-session -d -s main -c /home/developer/workspace -x 120 -y 30"

# Run custom initialization if provided
if [ -f "/home/developer/workspace/.init.sh" ]; then
    su - developer -c "sh /home/developer/workspace/.init.sh"
fi

echo "AI CLI Environment Ready!"
echo "SSH server running on port 22"
echo "Connect with: ssh developer@ssh.example.com -p 2222"

# Keep container running
tail -f /dev/null