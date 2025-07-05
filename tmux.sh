# Install tmux
echo "Installing tmux..."
sudo apt update
sudo apt install tmux -y

# tmux commands reference
echo "tmux commands reference..."
echo "Start a new session: tmux"
echo "Attach to a session: tmux attach-session -t 0"
echo "Create a new window: Ctrl + b, then c"
echo "Switch to the next window: Ctrl + b, then n"
echo "Switch to the previous window: Ctrl + b, then p"
echo "Split the window vertically: Ctrl + b, then %"
echo "Split the window horizontally: Ctrl + b, then \""
echo "Switch between panes: Ctrl + b, then arrow keys"
echo "Detach from tmux: Ctrl + b, then d"
echo "Close a window/pane: exit"
echo "List all windows: Ctrl + b, then w"
echo "Rename a window: Ctrl + b, then ,"
echo "List tmux sessions: tmux ls"
echo "Attach tmux session: tmux attach-session -t <session_name>"
# Enable Mouse Mode in the Global Configuration
set -g mouse on
tmux source-file /etc/tmux.conf