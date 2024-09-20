# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH="/home/tristan/.oh-my-zsh"
ZSH_THEME="avit"

plugins=(
	git
)

autoload -U compinit && compinit

source $ZSH/oh-my-zsh.sh

# User configuration
export EDITOR=nvim

#Aliases
alias vim=nvim
alias ls=lsd
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias symlink='ln -s'

#Aliases for rsync
cpr() {
  rsync --archive -hh --partial --info=stats1,progress2 --modify-window=1 "$@"
} 
mvr() {
  rsync --archive -hh --partial --info=stats1,progress2 --modify-window=1 --remove-source-files "$@"
}

#Startup command
fastfetch | lolcat --spread=1
