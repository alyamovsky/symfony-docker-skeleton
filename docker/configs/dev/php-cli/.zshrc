export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="bira"
plugins=(
  git
  composer
  symfony2
  encode64
  urltools
  ubuntu
)

source $ZSH/oh-my-zsh.sh

alias ls="ls -lah --color=auto"

umask 002