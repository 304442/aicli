#!/bin/sh
echo "🚀 AI CLI Ready!"
tmux send-keys -t main:0 'clear' C-m
tmux new-window -t main -n editor -c /home/developer/workspace && tmux split-window -h -p 30
tmux new-window -t main -n terminal -c /home/developer/workspace && tmux send-keys 'echo "Tools: rg gh nvim node python go rust"' C-m
tmux new-window -t main -n jupyter -c /home/developer/workspace && tmux send-keys 'echo "Lab: jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root"' C-m
tmux new-window -t main -n logs -c /home/developer/workspace && tmux send-keys 'echo "Logs & monitoring"' C-m
tmux select-window -t main:0
[ -z "$(git config --global user.email)" ] && git config --global user.email "${GIT_AUTHOR_EMAIL:-aicli@dev.local}" && git config --global user.name "${GIT_AUTHOR_NAME:-AI CLI Developer}"
echo "Windows: main(0) editor(1) terminal(2) jupyter(3) logs(4) | Web: http://localhost/jupyter/"