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

#allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD
## restart running processes on exit
#setopt HUP

## history
#setopt APPEND_HISTORY
## for sharing history between zsh processes
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

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
#alias screen="/usr/bin/screen -D -R"
alias console="sudo screen /dev/tty.usbserial 9600"
alias getfile="curl -O -C - "
alias gen-ospf-key="dd if=/dev/urandom count=1024 | shasum"
alias rename_logs="autoload zmv;zmv -W '*.log' '*.txt'"
if [[ `colordiff --help 2>&1 >/dev/null` -eq 0 ]];
then
    alias diff=colordiff
fi
alias grep="grep -E --color=auto"
alias egrep="grep -E --color=auto"
alias gcc="gcc -fdiagnostics-color=auto"
alias cat="highlight --out-format xterm256 --style moria --force --quiet"
alias tmux="`which -a tmux | tail -n 1` new-session -AD -s 0"
alias screen=tmux
alias update_oui="cd ~;curl -O http://standards-oui.ieee.org/oui/oui.txt"
alias pwsh="docker run --rm -it danwanderson/powershell"
alias go="docker run --rm -it danwanderson/go"
alias rancid="docker run --rm -it --mount source=rancid,destination=/usr/local/rancid danwanderson/rancid"
alias ansible='docker run --rm -v ${PWD}:/root -v ${HOME}/.ssh:/root/.ssh:ro -it danwanderson/ansible'
alias ansible-playbook='docker run --rm -v ${PWD}:/root -v ${HOME}/.ssh:/root/.ssh:ro --entrypoint ansible-playbook -it danwanderson/ansible'
alias az='docker run -it --rm -w="/root" --entrypoint /usr/local/bin/az -v ${PWD}:/root -v ${HOME}/.ssh:/root/.ssh:ro microsoft/azure-cli'
alias azpwsh='docker run -it --rm  --entrypoint /usr/local/bin/pwsh -v ${HOME}:/root azuresdk/azure-powershell'
alias wget='docker run -it --rm --entrypoint /usr/bin/wget -v ${PWD}:/data -w="/data/" inutano/wget'
alias systemstats="sudo systemstats"
alias bootstats="sudo systemstats -B current"
# Dumb hack to get around OSX built-in version
if [ -f /usr/local/bin/git ];
then
    alias git='/usr/local/bin/git'
fi
alias jigdo='docker run --rm -v ${PWD}:/root -it danwanderson/jigdo'


export LESS="-R"
export LESSOPEN="| $(which highlight) %s --out-format xterm256 --quiet --force --style moria"
# This is deprecated??
export GREP_OPTIONS='--color=auto' 
export GREP_COLORS="mt=34;42"

if [[ `uname -s` = "Darwin" ]]; then
    alias locate="mdfind"
    alias d="ls -G"
    alias ls="ls -G"
    alias l="ls -G"
    alias ll="ls -G -l"
elif [[ `uname -s` = "OpenBSD" ]]; then
    export PKG_PATH=http://openbsd.mirror.frontiernet.net/pub/OpenBSD/`uname -r`/packages/`machine -a`/
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

WIDTH=`stty size | cut -d ' ' -f 2`

if [[ (( $WIDTH -gt 132 )) ]]; then
    stty cols 132
fi


# Set screen window titles
function title {
  if [[ $TERM == "screen" ]]; then
    # Use these two for GNU Screen:
    print -nR $'\033k'$1$'\033'\\

    print -nR $'\033]0;'$2$'\a'
  elif [[ $TERM == "xterm" || $TERM == "rxvt" ]]; then
    # Use this one instead for XTerms:
    print -nR $'\033]0;'$*$'\a'
  fi
}

function precmd {
  title zsh "$PWD"
}

function preexec {
  emulate -L zsh
  local -a cmd; cmd=(${(z)1})
  title $cmd[1]:t "$cmd[2,-1]"
}

autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
#zstyle ':vcs_info:git:*' formats '%b'
zstyle ':vcs_info:git:*' formats " (%s)-[%b]%u%c-" actionformats " (%s)-[%b|%a]%u%c-"

# Syntax highlighting
# get it from https://github.com/zsh-users/zsh-syntax-highlighting.git
# or zprezto
if [ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]
then
  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  typeset -A ZSH_HIGHLIGHT_PATTERNS
  ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
  ZSH_HIGHLIGHT_PATTERNS+=('prod' 'fg-white,bold,bg=red')
  ZSH_HIGHLIGHT_STYLES[globbing]=fg=063
fi