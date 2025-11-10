export JDK_HOME="/usr/libexec/java_home"
export ANDROID_HOME="~/Library/Android/sdk"
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-21.jdk/Contents/Home"
alias python="python3"

export PATH="/opt/homebrew/bin:$PATH"
export PATH="/Applications/CMake.app/Contents/bin":"$PATH"
export PATH="/Users/zacharya/.local/bin:$PATH"
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH="/Library/TeX/texbin:$PATH"

export PATH="$PATH:/Applications/Docker.app/Contents/Resources/bin/"
export PATH="/Library/PostgreSQL/17/scripts:$PATH"

## Binds option left-arrow and option right-arrow to jump words
bindkey ";3C" forward-word
bindkey ";3D" backward-word

### Verbose PS1 Settings
###

autoload -Uz vcs_info add-zsh-hook
setopt PROMPT_SUBST
add-zsh-hook precmd vcs_info
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '%F{red}*%f'
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:git:*' formats ' 󰘬:%b%u%c'
zstyle ':vcs_info:git:*' actionformats ' 󰘬:%b|%a%u%c'

# Hook for showing untracked files
+vi-git-untracked() {
  if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
  [ -n "$(git status --porcelain 2> /dev/null)" ]; then
    hook_com[unstaged]+='%F{red}?%f'  # Add '?' for untracked files
  fi
}

# Git status settings
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked

PS1='%B%F{red}[%F{yellow}%n%F{green}${vcs_info_msg_0_} %5F%1~%F{red}]›%f%b '

###
### 

# Binds C-f to ThePrimeagen tmux fuzzy finder
chmod +x ~/dotfiles/zsh/tmux_launcher.sh
bindkey -s '^f' '~/dotfiles/zsh/tmux_launcher.sh\n'

