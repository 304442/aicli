#!/bin/sh
[ -f /home/developer/.initialized ] && echo "Environment ready, starting services..." || {
    echo "Installing packages..."
    echo -e "http://dl-cdn.alpinelinux.org/alpine/edge/main\nhttp://dl-cdn.alpinelinux.org/alpine/edge/community\nhttp://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
    apk update && apk add --no-cache openssh tmux fish neovim ripgrep github-cli curl git bash sudo shadow starship nodejs npm python3 py3-pip chromium chromium-chromedriver chromium-swiftshader xvfb dbus ttf-freefont build-base jq yq fzf bat exa fd httpie tree htop ncdu entr direnv make cmake go rust docker docker-compose wget unzip zip less
    pip3 install playwright requests beautifulsoup4 pandas numpy flask fastapi uvicorn pytest black jupyter jupyterlab notebook ipython matplotlib seaborn plotly nbconvert ipywidgets
    ssh-keygen -A && sed -i 's/#PermitRootLogin.*/PermitRootLogin no/;s/#PasswordAuthentication.*/PasswordAuthentication yes/;s/#PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
    echo -e "AllowUsers developer\nMatch User developer\n    ForceCommand /usr/bin/tmux attach -t main || /usr/bin/tmux new -s main" >> /etc/ssh/sshd_config
    adduser -D -s /bin/fish developer && echo "developer:developer" | chpasswd && adduser developer wheel && echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
    mkdir -p /home/developer/.ssh /home/developer/.config/fish
    echo -e "starship init fish | source\ndirenv hook fish | source\nalias ll='exa -la'\nalias ls='exa'\nalias cat='bat'\nalias find='fd'\nalias vim='nvim'\nalias grep='rg'\nalias top='htop'" >> /home/developer/.config/fish/config.fish
    chown -R developer:developer /home/developer && chmod 700 /home/developer/.ssh
    su - developer -c "touch /home/developer/.initialized && playwright install chromium firefox webkit"
}
mkdir -p /run/sshd && /usr/sbin/sshd
[ "$ENABLE_DISPLAY" = "true" ] && Xvfb :99 -screen 0 1920x1080x24 -nolisten tcp & export DISPLAY=:99
[ -f /home/developer/workspace/.ssh/authorized_keys ] && cp /home/developer/workspace/.ssh/authorized_keys /home/developer/.ssh/ && chmod 600 /home/developer/.ssh/authorized_keys && chown developer:developer /home/developer/.ssh/authorized_keys
chown developer:developer /home/developer/.tmux.conf 2>/dev/null || true
su - developer -c "tmux new-session -d -s main -c /home/developer/workspace"
[ -f "/home/developer/workspace/.init.sh" ] && su - developer -c "sh /home/developer/workspace/.init.sh"
echo "AI CLI Environment Ready! SSH: ssh developer@ssh.example.com -p 2222"
tail -f /dev/null