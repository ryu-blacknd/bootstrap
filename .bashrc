[[ "$-" != *i* ]] && return

alias ..='cd ..'
alias ls='ls --color=tty'
alias l='ls -al'
alias vi='vim'
alias vimrc='vim ~/.vimrc'
alias bashrc='vim ~/.bashrc'
alias wget='wget --no-check-certificate'

PS1='\[\033[32m\][\u@\h \W]#\[\033[0m\] '

sh ~/molokai.sh
eval $(dircolors -b ~/.dir_colors)

