ln -hs ~/dotfiles/alacritty ~/.config/alacritty
ln -hs ~/dotfiles/nvim ~/.config/nvim
ln -hs ~/dotfiles/tmux ~/.config/tmux
ln -hs ~/dotfiles/zsh/.zshrc ~/.zshrc
ln -hs ~/dotfiles/aerospace ~/.config/aerospace

# Setup tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Check if we're already inside a tmux session
if [ -z "$TMUX" ]; then
    # If not inside a tmux session, start a new one and run commands in it
    tmux new-session -d -s install-session

    # Source tmux configuration file
    tmux send-keys -t install-session "tmux source-file ~/.config/tmux/tmux.conf" C-m

    # Run the plugin installation
    tmux send-keys -t install-session "tmux run-shell ~/.tmux/plugins/tpm/bin/install_plugins" C-m

    # After running the commands, kill the tmux session
    tmux send-keys -t install-session "tmux kill-session -t install-session" C-m

    echo "Setup tmux configurations"
else
    # If already inside a tmux session, just run the commands
    tmux source-file ~/.config/tmux/tmux.conf
    tmux run-shell "~/.tmux/plugins/tpm/bin/install_plugins"
fi
