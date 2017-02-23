#
# /etc/zshrc is sourced in interactive shells.  It
# should contain commands to set up aliases, functions,
# options, key bindings, etc.
#
#complist
autoload -U compinit
compinit
#ZLS_COLORS=$LS_COLORS
LSCOLORS="gxfxcxdxbxegedabagacad"
export LSCOLORS

autoload -U promptinit
promptinit

autoload colors
colors
# dan prompt theme (based on gentoo prompt theme)

prompt_dan_help () {
  cat <<'EOF'
This prompt is color-scheme-able.  You can invoke it thus:

  prompt dan [<promptcolor> [<usercolor> [<rootcolor>]]]

EOF
}

prompt_dan_setup () {
  prompt_dan_prompt=${1:-'blue'}
  prompt_dan_user=${2:-'green'}
  prompt_dan_root=${3:-'red'}

  if [ "$USER" = 'root' ]
  then
    base_prompt="%{$fg_bold[$prompt_dan_root]%}%m%{$reset_color%} "
  else
    base_prompt="%{$fg_bold[$prompt_dan_user]%}%n@%m%{$reset_color%} "
  fi
  post_prompt="%{$reset_color%}"

  local color="%{*}"
  base_prompt_no_color="${(S)base_prompt//${~color}/}"
  post_prompt_no_color="${(S)post_prompt//${~color}/}"

  setopt noxtrace localoptions
  local base_prompt_expanded_no_color base_prompt_etc
  local prompt_length space_left

  base_prompt_expanded_no_color=$(print -P "$base_prompt_no_color")
  base_prompt_etc=$(print -P "$base_prompt%(4~|...|)%3~")
  prompt_length=${#base_prompt_etc}
  path_prompt="%{$fg_bold[$prompt_dan_prompt]%}%~"
  PS1="$base_prompt$path_prompt %# $post_prompt"
  PS2="$base_prompt$path_prompt %_> $post_prompt"
  PS3="$base_prompt$path_prompt ?# $post_prompt"

  precmd  () { }
  preexec () { }
}

#prompt_dan_setup "$@"
prompt_dan_setup cyan green red


#prompt gentoo
#if [[ `prompt -l` = *dan* ]]; then
#    prompt dan
#else
#    prompt suse
#fi

# Turn on minicom line wrapping
MINICOM="-w"
export MINICOM

alias ipcalc="sipcalc -4"
#alias tt="tt++ /home/dwa/.tt-config"
alias screen="/usr/bin/screen -D -R"
#alias mkpasswd="/usr/bin/passook -p 4"
alias gpg="/usr/local/bin/gpg"
#alias console="sudo screen /dev/tty.PL2303-0000101D 9600"
alias console="sudo screen /dev/tty.usbserial 9600"
#alias console1="sudo screen /dev/tty.PL2303-0000201A 9600"
#alias engsql="ssh user@server -L 3306:127.0.0.1:3306"
#alias mntosiris="sshfs danderson@osiris:/home/danderson ssh_mount -oauto_cache,reconnect,volname=Osiris"
alias getfile="curl -O -C - "
alias gen-ospf-key="dd if=/dev/urandom count=1024 | shasum"

if [[ `uname -s` = "Darwin" ]]; then
    alias locate="mdfind"
    alias d="ls -G"
    alias ls="ls -G"
    alias l="ls -G"
    alias ll="ls -G -l"
elif [[ `uname -s` = "OpenBSD" ]]; then
    export PKG_PATH=http://openbsd.mirror.frontiernet.net/pub/OpenBSD/5.5/packages/`machine -a`/
    alias ls="ls -F"
else
    if [[ -f /etc/DIR_COLORS ]]; then
        eval `dircolors -b /etc/DIR_COLORS`
    fi
    alias d="ls --color"
    alias ls="ls --color=auto"
    alias l="ls --color=auto"
    alias ll="ls --color -l"
fi

## shell functions
#setenv() { export $1=$2 }  # csh compatibility

# Set prompts
#PROMPT='[%n@%m]%~%# '    # default prompt
#RPROMPT=' %~'     # prompt for right side of screen

bindkey -v             # vi key bindings
# bindkey -e             # emacs key bindings
#bindkey ' ' magic-space  # also do history expansion on space


# ~/.zshrc
# if using GNU screen, let the zsh tell screen what the title and hardstatus
# of the tab window should be.
if [[ $TERM = "screen" ]]; then
  # use the current user as the prefix of the current tab title (since that's
  # fairly important, and I change it fairly often)
  TAB_TITLE_PREFIX='"${USER}$PROMPT_CHAR"'
  # when at the shell prompt, show a truncated version of the current path (with
  # standard ~ replacement) as the rest of the title.
  TAB_TITLE_PROMPT='`echo $PWD | sed "s/^\/home\//~/;s/^~$USER/~/;s/\/..*\//\/...\//"`'
  # when running a command, show the title of the command as the rest of the
  # title (truncate to drop the path to the command)
  TAB_TITLE_EXEC='$cmd[1]:t'
 
  # use the current path (with standard ~ replacement) in square brackets as the
  # prefix of the tab window hardstatus.
  TAB_HARDSTATUS_PREFIX='"[`echo $PWD | sed "s/^\/home\//~/;s/^~$USER/~/"`] "'
  # when at the shell prompt, use the shell name (truncated to remove the path t o
  # the shell) as the rest of the title
  TAB_HARDSTATUS_PROMPT='$SHELL:t'
  # when running a command, show the command name and arguments as the rest of
  # the title
  TAB_HARDSTATUS_EXEC='$cmd'
 
  # tell GNU screen what the tab window title ($1) and the hardstatus($2) should be
  function screen_set()
  {  
    #  set the tab window title (%t) for screen
    print -nR $'\033k'$1$'\033'\\\

    # set hardstatus of tab window (%h) for screen
    print -nR $'\033]0;'$2$'\a'
  }
  # called by zsh before executing a command
  function preexec()
  {
    local -a cmd; cmd=(${(z)1}) # the command string
    eval "tab_title=$TAB_TITLE_PREFIX$TAB_TITLE_EXEC"
    eval "tab_hardstatus=$TAB_HARDSTATUS_PREFIX$TAB_HARDSTATUS_EXEC"
    screen_set $tab_title $tab_hardstatus
  }
  # called by zsh before showing the prompt
  function precmd()
  {
    eval "tab_title=$TAB_TITLE_PREFIX$TAB_TITLE_PROMPT"
    eval "tab_hardstatus=$TAB_HARDSTATUS_PREFIX$TAB_HARDSTATUS_PROMPT"
    screen_set $tab_title $tab_hardstatus
  }
fi


case $TERM in
#    xterm*|screen*)
    xterm*)
        precmd () {print -Pn "\e]0;%n@%m: %~\a"}
        preexec () { print -Pn "\e]0;%n@%m: $1\a" }
        #preexec () { print -Pn "\e]0;%n@%m: $*\a" }   #OLD
        ;;
esac

export HISTSIZE=2000
export HISTFILE=~/.zsh_history
export SAVEHIST=$HISTSIZE

zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
setopt correctall

if [[ -f /usr/bin/vim ]]; then
    export EDITOR=/usr/bin/vim
elif [[ -f /usr/bin/vi ]]; then
    export EDITOR=/usr/bin/vi
fi

export PAGER=less

# use the built in directory navigation via the directory stack
# depth of the directory history
DIRSTACKSIZE=30
# automatic pushd
setopt AUTO_PUSHD
# exchange meaning of + and -
setopt PUSHD_MINUS
# don't tell me about automatic pushd
#setopt PUSHD_SILENT
# use $HOME when no arguments specified
setopt PUSHD_TO_HOME
# ignore duplicates
setopt PUSHD_IGNOREDUPS
