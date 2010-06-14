# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color)
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    ;;
*)
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    ;;
esac


# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ] && [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias lock='cmatrix -s && vlock'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# couleurs
C_RED="\[\e[1;31m\]"
C_BLUE="\[\e[1;34m\]"
C_GRAY="\[\e[1;30m\]"
C_WHITE="\[\e[1;37m\]"
C_YELLOW="\[\e[1;33m\]"
C_DEF="\[\033[0m\]"
 
mUID=`id -u`
MACHINE=`hostname`
IP=`ifconfig eth0 | awk '$1 == "inet" { split($2,Trunc,":"); print Trunc[2] }'`
 
if [ "$mUID" = "0" ] ; then
   PS1="${C_YELLOW}>${C_DEF} ${C_RED}\u${C_DEF}@${MACHINE}${C_YELLOW}[${C_DEF}$IP${C_YELLOW}]${C_WHITE}:\w${C_RED}#${C_DEF} "
   PS2="${C_RED}>${C_DEF}  "
else
   PS1="${C_YELLOW}>${C_DEF} ${C_BLUE}\u${C_DEF}@${MACHINE}${C_YELLOW}[${C_DEF}$IP${C_YELLOW}]${C_WHITE}:\w${C_BLUE}\$ ${C_DEF}"
   PS2="${C_BLUE}>${C_DEF}  "
fi

if [ "$PS1" ]; then
  complete -cf sudo
fi
 
export PS2
export PS1
