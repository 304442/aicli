#!/bin/sh
[ -f /.initialized ] && echo "Environment ready, starting services..." || {
    echo "Installing packages..."
    echo -e "http://dl-cdn.alpinelinux.org/alpine/edge/main\nhttp://dl-cdn.alpinelinux.org/alpine/edge/community\nhttp://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
    apk update && apk add --no-cache openssh tmux fish neovim ripgrep github-cli curl git bash starship nodejs npm python3 py3-pip chromium chromium-chromedriver chromium-swiftshader xvfb dbus ttf-freefont build-base jq yq fzf bat exa fd httpie tree htop ncdu entr direnv make cmake go rust docker docker-compose wget unzip zip less
    pip3 install playwright requests beautifulsoup4 pandas numpy flask fastapi uvicorn pytest black jupyter jupyterlab notebook ipython matplotlib seaborn plotly nbconvert ipywidgets
    ssh-keygen -A && sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/;s/#PasswordAuthentication.*/PasswordAuthentication yes/;s/#PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
    echo -e "ForceCommand /usr/bin/tmux attach -t main || /usr/bin/tmux new -s main" >> /etc/ssh/sshd_config
    mkdir -p /root/.ssh /root/.config/fish
    echo -e "starship init fish | source\ndirenv hook fish | source\nalias ll='exa -la'\nalias ls='exa'\nalias cat='bat'\nalias find='fd'\nalias vim='nvim'\nalias grep='rg'\nalias top='htop'" >> /root/.config/fish/config.fish
    chmod 700 /root/.ssh && echo "root:root" | chpasswd
    touch /.initialized && playwright install chromium firefox webkit
}
mkdir -p /run/sshd && /usr/sbin/sshd
[ "$ENABLE_DISPLAY" = "true" ] && Xvfb :99 -screen 0 1920x1080x24 -nolisten tcp & export DISPLAY=:99
[ -f /workspace/.ssh/authorized_keys ] && cp /workspace/.ssh/authorized_keys /root/.ssh/ && chmod 600 /root/.ssh/authorized_keys
tmux new-session -d -s main -c /workspace
[ -f "/workspace/.init.sh" ] && sh /workspace/.init.sh
echo "AI CLI Environment Ready! SSH: ssh root@ssh.example.com -p 2222"
tail -f /dev/null