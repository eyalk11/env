# -*-  mode: shell-script; -*-
# vim: ft=sh:fdm=marker:fmr={[},{]}

# Enable smart completion in bash
if [ -f /etc/bash_completion ]; then
 . /etc/bash_completion
fi

# You know it, baby. Shouldn't need to use nano ever
export EDITOR="vim --noplugin --cmd \"let g:noPlugins=1\""
export VISUAL="vim --cmd \"let g:liteMode=1\""
export GIT_EDITOR="vim --cmd \"let g:liteMode=1\""

# {[} Terminal settings
USENF=${NERDFONT-0}
USEPF=${POWERLINE-0}
COLORTERM=${COLORTERM-16}
TERM_PROGRAM=${TERM_PROGRAM-}
TERMOPTIONS=(USENF USEPF COLORTERM TERM_PROGRAM)
EXPORT_TERMOPTIONS=""
for option in ${TERMOPTIONS[*]}; do
    EXPORT_TERMOPTIONS="${EXPORT_TERMOPTIONS} export ${option}=${!option};"
done
sshn(){
    host=$1
    ssh -t $host "${EXPORT_TERMOPTIONS} bash -l"
}
alias ssh="sshn"
# {]} Terminal settings

# Source .dir_colours
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolours_solarized && eval "$(dircolors -b ~/.dircolours_solarized)" || eval "$(dircolors -b)"
fi

export LC_CTYPE="en_US.UTF-8"
# Allow sending ctrl+S to applications in terminal (prev stops scrolling)
stty -ixon

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=1000
export HISTFILESIZE=2000
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
export HISTCONTROL=ignoredups:erasedups
if [ ! -d "${HOME}/.logs" ] ; then
   mkdir ${HOME}/.logs
fi
PROMPT_COMMAND="${PROMPT_COMMAND} && log_command"
# Save to history when command is executed, rather than when terminal is closed.
# Then reread it.
# PROMPT_COMMAND="${PROMPT_COMMAND} && history -a; history -c; history -r"
PROMPT_COMMAND="${PROMPT_COMMAND} && _bash_history_sync"
# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
# # If set, the pattern "**" used in a pathname expansion context will
# # match all files and zero or more directories and subdirectories.
#shopt -s globstar
# No init prevents screen being cleared on enter/exit.
# Window=4 is scrolling buffer.
# export LESS='--quit-if-one-screen --ignore-case --status-column --HILITE-UNREAD --tabs=4 --window=-4'
export LESS='--quit-if-one-screen --ignore-case --status-column --LONG-PROMPT --HILITE-UNREAD --tabs=4 --no-init --window=-4 --RAW-CONTROL-CHARS'
# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [[ "$OSTYPE" =~ "darwin1" ]]; then  # OSX specific stuff
    # Solarized ls dircolours (sort of)
    export CLICOLOR=1
    # Recommended... but wrong?
    # export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
    # Custom, created from comparing website and ls man
    export LSCOLORS=exgxbAbAcxbhxbhBhDhcea
    export HOMEBREW_PREFIX="$HOME/homebrew"
    # Make esc act as backspace in terminal
    # todo
    # Remove tab menu completion :( (Doesn't work on OSX).
    bind 'Tab: complete'

elif [ "$OSTYPE" = "linux-gnu" ]; then  # Linux specific stuff
   # Linuxbrew paths
   export HOMEBREW_PREFIX="$HOME/.linuxbrew"
fi

# brew paths
export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH"
export XDG_DATA_DIRS="/$HOMEBREW_PREFIX/share:$XDG_DATA_DIRS"
export MANPATH="$HOMEBREW_PREFIX/share/man:$MANPATH"
export INFOPATH="$HOMEBREW_PREFIX/share/info:$INFOPATH"

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  elif [ -f $HOMEBREW_PREFIX/etc/bash_completion ]; then
      . $HOMEBREW_PREFIX/etc/bash_completion
  fi
fi
# TODO Maybe bad... should you mess with $TERM?
# [[ -n "$DISPLAY" && "$TERM" = "xterm" ]] && export TERM=xterm-256color

# make less more friendly for non-text input files, see lesspipe(0)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
