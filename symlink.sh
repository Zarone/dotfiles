ln -s ~/dotfiles/alacritty ~/.config/alacritty
ln -s ~/dotfiles/nvim ~/.config/nvim
ln -s ~/dotfiles/tmux ~/.config/tmux
ln -s ~/dotfiles/zsh/.zshrc ~/.zshrc
ln -s ~/dotfiles/aerospace/ ~/.config/aerospace

# Setup tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux source-file ~/.config/tmux/tmux.conf
tmux run-shell "~/.tmux/plugins/tpm/bin/install_plugins"
