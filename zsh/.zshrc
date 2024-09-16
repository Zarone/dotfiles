export JDK_HOME="/usr/libexec/java_home"
export ANDROID_HOME="~/Library/Android/sdk"
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-21.jdk/Contents/Home"

export PATH="/opt/homebrew/bin:$PATH"
export PATH="/Applications/CMake.app/Contents/bin":"$PATH"
export PATH="/Users/zacharya/.local/bin:$PATH"
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

export TERM=xterm-256color

# Binds option left-arrow and option right-arrow to jump words
bindkey ";3C" forward-word
bindkey ";3D" backward-word

# PS1 Settings
autoload -Uz vcs_info add-zsh-hook
setopt PROMPT_SUBST
add-zsh-hook precmd vcs_info
PROMPT='%1~ %F{red}${vcs_info_msg_0_}%f %# '
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '%F{red}*%f'
zstyle ':vcs_info:*' stagedstr '+'

zstyle ':vcs_info:git:*' formats ' 󰘬:%b%u%c'
zstyle ':vcs_info:git:*' actionformats ' 󰘬:%b|%a%u%c'
PS1='%B%F{red}[%F{yellow}%n%F{green}${vcs_info_msg_0_} %5F%1~%F{red}]›%f%b '


