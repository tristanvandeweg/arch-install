# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH="/home/tristan/.oh-my-zsh"
ZSH_THEME="avit"

plugins=(
	git
	zsh-completions
	zsh-autosuggestions
)

autoload -U compinit && compinit

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"
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
if [[ $TERM_APP ==  'konsole' ]]; then 
neofetch | lolcat --spread=1
fi
