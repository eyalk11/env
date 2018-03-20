# -*-  mode: shell-script; -*-
# vim: set ft=sh:

# Always used
shopt -s expand_aliases

alias cl="clear"
alias ..="cd .. && ls"
alias cd..="cd .. && ls"

alias ls="ls -CF"
alias lsa="ls -aF"
alias ll="ls -alF"
alias l='ls -CF'
alias open="nautilus $1 >/dev/null 2>&1"
alias :q="exit"
alias :Q="exit"
alias ZZ="exit"

alias gca="git commit -a"
alias gc="git_clone"

# Try to set vim to xvim (has x11 clipboard support)
if [ -e /usr/bin/vimx ]; then
    alias vim='/usr/bin/vimx'
elif [ -e /usr/bin/gvim ]; then
    alias vim='/usr/bin/gvim -v'
fi

alias qvim="vim --noplugin"

# Prevent files from being overwritten by redirection.
set -o noclobber
# Don't accidentally remove or overwrite files.
alias cp="cp -i"
alias mv="mv -i"

if [ -d "$HOME/.redis" ]; then
    alias redis="cd $HOME/.redis/redis-server"
fi

if [ -d "$HOME/workspace" ]; then
    alias ws="cd $HOME/workspace"
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    #alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
