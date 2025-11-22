#! /usr/bin/env zsh

# /etc/zshrc is sourced in interactive shells.  It
# should contain commands to set up aliases, functions,
# options, key bindings, etc.

#### Begin from oh-my-zsh default .zshrc

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=/opt/homebrew/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="fino-time-dwa"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
#DISABLE_UPDATE_PROMPT="true"
zstyle ':omz:update' mode auto

#zstyle ':omz:update' verbose default # default update prompt

zstyle ':omz:update' verbose minimal # only few lines

#zstyle ':omz:update' verbose silent # only errors

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# eza configuration
NO_GIT_HOSTNAMES=()
zstyle ':omz:plugins:eza' 'dirs-first' yes
if [[ "${NO_GIT_HOSTNAMES[@]}" =~ $(hostname) ]];
then
    zstyle ':omz:plugins:eza' 'git-status' no
else
    zstyle ':omz:plugins:eza' 'git-status' yes
fi
zstyle ':omz:plugins:eza' 'header' yes
zstyle ':omz:plugins:eza' 'icons' yes
zstyle ':omz:plugins:eza' 'size-prefix' si
zstyle ':omz:plugins:eza' 'time-style' long-iso
zstyle ':omz:plugins:eza' 'hyperlink' no

if [[ -d ~/.oh-my-zsh/custom/plugins/zsh-autopair ]];
then
    source ~/.oh-my-zsh/custom/plugins/zsh-autopair/autopair.zsh
    autopair-init
fi

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting colored-man-pages z zsh-interactive-cd cp)

if [ -f $ZSH/oh-my-zsh.sh ];
then
    source $ZSH/oh-my-zsh.sh
fi

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

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


#### END from oh-my-zsh default .zshrc



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

fpath=(~/.zsh_completion $fpath)

# Returns whether the given command is executable or aliased.
_has() {
  return $( whence -p $1 &>/dev/null )
}

# Returns whether the given statement executed cleanly. Try to avoid this
# because this slows down shell loading.
_try() {
  return $( eval $* &>/dev/null )
}

# Homebrew on OSX
if [ -x /opt/homebrew/bin/brew ];
then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Linux Homebrew paths
if [ -x /home/linuxbrew/.linuxbrew/bin/brew];
then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Homebrew on OSX installed in home directory
if [ -x /Users/${USER}/homebrew/bin/brew ];
then
    eval "$(/Users/${USER}/homebrew/bin/brew shellenv)"
fi

if _has sipcalc; then
    alias ipcalc="sipcalc -4"
fi

# screen replaced by tmux in my day-to-day
# screen - attach here NOW and disconnect any other sessions
#alias screen="/usr/bin/screen -D -R"
alias console="sudo screen /dev/tty.usbserial 9600"
alias getfile="curl -O -C - "
# Generate OSPFv3 keys
alias gen-ospf-key="dd if=/dev/urandom count=1024 | shasum"
# Bulk rename of logs from RoyalTSX
# For some reason, they don't let you change the file suffix
alias rename_logs="autoload zmv;zmv -W '*.log' '*.txt'"
alias install_tpm="git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm"
alias install_theme="cp ~/dotfiles/fino-time-dwa.zsh-theme ~/.oh-my-zsh/custom/themes"
alias setup_vim="git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim && vim +PluginInstall +qall"
alias update_vim="vim +PluginUpdate +qall"

# Add homebrew update if availalble
if _has brew;
then
    alias bu="brew update && brew upgrade && brew upgrade --cask"
fi

# if gawk is avaliable, use that
if _has gawk;
then
    alias awk=gawk
fi

# if gsed is avaliable, use that
if _has gsed;
then
    alias sed=gsed
fi

# Add apt update if availalble
if _try apt --help;
then
    alias au="sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y"
fi

# Add apk update if availalble
if _has apk;
then
    alias au="sudo apk upgrade --update-cache"
fi

# Use colordiff if it's available
if _has colordiff;
then
    alias diff=colordiff
fi

# Turn on grep colors and alias grep to egrep
alias grep="grep -E --color=auto"
alias egrep="grep -E --color=auto"

# Turn on colors for GCC
alias gcc="gcc -fdiagnostics-color=auto"

# use highlight if it's available
if _has highlight;
then
    alias cat="$(whence -p highlight) --out-format xterm256 --style moria --force --quiet --stdout"
    alias rcat=/bin/cat
    export LESSOPEN="| $(which highlight) %s --out-format xterm256 --quiet --force --style moria"
fi

# Debian...
if _has batcat;
then
    alias bat="$(whence -p batcat)"
    alias cat="$(whence -p batcat)"
    export BAT_THEME="Coldark-Dark"
fi

# use bat if a available
if _has bat;
then
    alias cat=bat
    export BAT_THEME="Coldark-Dark"
fi

if _has tmux;
then
    alias tmux="$(whence -p tmux) new-session -AD -s 0"
    alias screen=tmux
fi

# Update IEEE OUI file locally
alias update_oui="cd ~;curl -O https://standards-oui.ieee.org/oui/oui.txt"


if _has hg;
then
    #omz plugin enable mercurial &>/dev/null
    omz plugin load mercurial &>/dev/null
fi

# Check to see if we have Docker installed
if _has docker;
then
    # If powershell isn't installed locally, use the container
    # if ! _has pwsh;
    # then
    #     alias pwsh="docker run --rm -it danwanderson/powershell"
    # fi
    # If Go isn't installed locally, use the container
    # if ! _has go;
    # then
    #     alias go="docker run --rm -it danwanderson/go"
    # fi

    # if Telnet isn't installed locally, use the container
    if ! _has telnet;
    then
        alias telnet="docker run --rm -it danwanderson/telnet"
    fi
    # if ansible isn't installed locally, use the container
    # if ! _has ansible;
    # then
    #     alias ansible='docker run --rm -v ${PWD}:/home/ansible -v ${HOME}/.ssh:/home/ansible/.ssh:ro -it danwanderson/ansible'
    #     alias ansible-playbook='docker run --rm -v ${PWD}:/home/ansible -v ${HOME}/.ssh:/home/ansible/.ssh:ro --entrypoint ansible-playbook -it danwanderson/ansible'
    #     alias ansible-vault='docker run --rm -v ${PWD}:/home/ansible -v ${HOME}/.ssh:/home/ansible/.ssh:ro --entrypoint ansible-vault -it danwanderson/ansible'
    #     alias ansible-galaxy='docker run --rm -v ${PWD}:/home/ansible -v ${HOME}/.ssh:/home/ansible/.ssh:ro --entrypoint ansible-galaxy -it danwanderson/ansible'
    # fi
    # if Azure CLI isn't installed locally, use the container
    # if ! _has az;
    # then
    #     alias az='docker run -it --rm -w="/root" --entrypoint /usr/local/bin/az -v ${PWD}:/root -v ${HOME}/.ssh:/root/.ssh:ro microsoft/azure-cli'
    #     alias azpwsh='docker run -it --rm  --entrypoint /usr/local/bin/pwsh -v ${HOME}:/root azuresdk/azure-powershell'
    # fi
    # Jigdo container (for Debian images)
    alias jigdo='docker run --rm -v ${PWD}:/home/jigdo -it danwanderson/jigdo'
    # If wget isn't installed locally, use the container
    if ! _has wget;
    then
        alias wget='docker run -it --rm --entrypoint /usr/bin/wget -v ${PWD}:/data -w="/data/" inutano/wget'
    fi

    alias docker-autocompose='docker run --rm -v /var/run/docker.sock:/var/run/docker.sock ghcr.io/red5d/docker-autocompose'
fi

# OSX
alias systemstats="sudo systemstats"
alias bootstats="sudo systemstats -B current"

# Find recursive symlinks
alias find_recursive_symlinks="find -L ."

alias reload_zshrc="source ~/.zshrc"

# Colors in less
export LESS="-R"
# This is deprecated??
#export GREP_OPTIONS='--color=auto'
export GREP_COLORS="mt=34;42"


if _has fzf;
then
    # FZF default
    if _has fdfind;
    then
        FD_CMD=fdfind
    elif _has fd-find;
    then
        FD_CMD=fd-find
    else
        FD_CMD=fd
    fi

    if [[ $(${FD_CMD} --version) =~ "8.2.1" ]];
    then
        export FZF_DEFAULT_COMMAND="${FD_CMD} --type f"
    else
        export FZF_DEFAULT_COMMAND="${FD_CMD} --type f --strip-cwd-prefix"
    fi

    export FZF_DEFAULT_OPTS="--style full \
        --preview 'fzf-preview.sh {}' --bind 'focus:transform-header:file --brief {}'"

    function fcd() {
        cd "$(${FD_CMD} --type d | fzf)"
    }

    function fcd1() {
        cd "$(${FD_CMD} --type d --max-depth 1 | fzf)"
    }
    #omz plugin enable fzf &>/dev/null
    omz plugin load fzf &>/dev/null
fi

# HOSTTYPE = { Linux | OpenBSD | SunOS | etc. }
if which uname &>/dev/null; then
  HOSTTYPE=`uname -s`
else
  HOSTTYPE=unknown
fi
export HOSTTYPE


if [[ "$HOSTTYPE" = "Darwin" ]]; then
    alias locate="mdfind"
    alias d="ls -G"
    alias ls="ls -G"
    alias l="ls -G"
    alias ll="ls -G -l"
    # Dumb hack to get around OSX built-in version
    if [ -f /usr/local/bin/git ];
    then
        alias git='/usr/local/bin/git'
    fi
    alias dirsize="du -h -d 1 | sort -h;df -hP ."
fi

if [[ "$HOSTTYPE" = "FreeBSD" ]]; then
    alias d="ls -G"
    alias ls="ls -G"
    alias l="ls -G"
    alias ll="ls -G -l"
    alias dirsize="du -h --max-depth=1 | sort -h; df --human-readable ."
fi

if [[ "$HOSTTYPE" = "OpenBSD" ]]; then
    export PKG_PATH=http://openbsd.mirror.frontiernet.net/pub/OpenBSD/$(uname -r)/packages/$(machine -a)/
    alias ls="ls -F"
    alias dirsize="du -h --max-depth=1 | sort -h"
fi

if [[ "$HOSTTYPE" = "Linux" ]]; then
    if [[ -f /etc/DIR_COLORS ]]; then
        eval $(dircolors -b /etc/DIR_COLORS)
    fi
    alias d="ls --color"
    alias ls="ls -F --color=auto"
    alias l="ls --color=auto"
    alias ll="ls --color -l"
    alias dirsize="du -h --max-depth=1 | sort -h; df --human-readable ."
fi

# eza - needs to be after the above aliases or stuff won't work right
if _has eza; then
    #omz plugin enable eza &>/dev/null
    omz plugin load eza &>/dev/null

    alias els="eza"
    if $(eza --version | grep "+git" &>/dev/null);
    then
        # built without git support
        alias ela="eza --long --all --header --time-style=long-iso --icons"
        alias ell="eza --long --header --time-style=long-iso --icons"
        alias elt="eza --long --tree --header --time-style=long-iso --icons"
        alias elm="eza --long --header --time-style=long-iso --modified --icons"
    else
        alias ela="eza --git --long --all --header --time-style=long-iso --icons"
        alias ell="eza --git --long --header --time-style=long-iso --icons"
        alias elt="eza --git --long --tree --header --time-style=long-iso --icons"
        alias elm="eza --git --long --header --time-style=long-iso --modified --icons"
    fi
fi

if _has rustc;
then
    #omz plugin enable rust &>/dev/null
    omz plugin load rust &>/dev/null
fi

if _has mosh;
then
    #omz plugin enable mosh &>/dev/null
    omz plugin load mosh &>/dev/null
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
        function precmd () {
            print -Pn "\e]0;%n@%m: %~\a"
        }
        function preexec () {
            print -Pn "\e]0;%n@%m: $1\a"
        }
        #preexec () { print -Pn "\e]0;%n@%m: $*\a" }   #OLD
        ;;
esac

export HISTSIZE=2000
export HISTFILE=~/.zsh_history
export SAVEHIST=$HISTSIZE

zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
setopt correctall

# Ignore useless files, like .pyc.
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/).pyc'

# Completing process IDs with menu selection.
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always

# Load menu-style completion.
zmodload -i zsh/complist
# bindkey -M menuselect '^M' accept

# Editor of choice (vim->vi->nano)
if _has vim;
then
    export EDITOR=vim
    alias vi=vim
elif _has vi;
then
    export EDITOR=vi
else
    export EDITOR=nano
fi

# Set pager to less
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


# Why did I do this? Seems to cause more problems than it solves
# try to update the terminal size
#WIDTH=`stty size | cut -d ' ' -f 2`

#if [[ (( $WIDTH -gt 132 )) ]]; then
#    stty cols 132
#fi


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

function install_omz() {
    if _has git;
    then
        git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
        git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
        git clone https://github.com/hlissner/zsh-autopair.git ~/.oh-my-zsh/custom/plugins/zsh-autopair
        exec zsh
    else
        echo "Please install git first"
    fi
}

function update_omz() {
    if _has git;
    then
        cd ~/.oh-my-zsh && git pull
        cd ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && git pull
        cd ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions && git pull
        cd ~/.oh-my-zsh/custom/plugins/zsh-autopair && git pull
        cd ~
        exec zsh
    else
        echo "Please install git first"
    fi
}

# Syntax highlighting
typeset -A ZSH_HIGHLIGHT_PATTERNS
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
ZSH_HIGHLIGHT_PATTERNS+=('prod' 'fg-white,bold,bg=red')
ZSH_HIGHLIGHT_STYLES[globbing]=fg=063

## Verbose copy by default
for c in cp rm chmod chown rename mv; do
  alias $c="$c -v"
done


# Humanize disk space if possible
if _try df -H ~; then
  alias df='df -H'
elif _try df -h ~; then
  alias df='df -h'
fi

if _has fping;
then
    alias ping='fping'
fi

# Misc
validate_mac() {
    local MAC=$(echo "${1}" | tr '[:upper:]' '[:lower:]' | sed -e 's/ //g')

    # 56:5e:f7:a5:f8:fd
    if [[ "${MAC}" =~ ^[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2} ]];
    then
        return 0
    fi

    # 56-5e-f7-a5-f8-fd
    if [[ "${MAC}" =~ ^[0-9a-f]{2}-[0-9a-f]{2}-[0-9a-f]{2}-[0-9a-f]{2}-[0-9a-f]{2}-[0-9a-f]{2} ]];
    then
        return 0
    fi

    # 565e.f7a5.f8fd
    if [[ "${MAC}" =~ ^[0-9a-f]{4}\.[0-9a-f]{4}\.[0-9a-f]{4} ]];
    then
        return 0
    fi

    # 565ef7a5f8fd
    if [[ "${MAC}" =~ ^[0-9a-f]{12} ]];
    then
        return 0
    fi

    VALID=0
    # 1:0:5e:0:0:fb
    for bits in $(echo "${MAC}" | awk -F ':' '{print $1, $2, $3, $4, $5, $6}' | tr '[:upper:]' '[:lower:]')
    do
        if ! [[ "${bits}" =~ ^[0-9a-f]{1,2}$ ]];
        then
            return 1
        else
            VALID=$(( ${VALID} + 1 ))
        fi
    done

    if [ ${VALID} -eq 6 ];
    then
        return 0
    fi

    # None of the above - it's not a MAC
    return 1
}

sanitize_mac() {
    local MAC="${1}"
    if ! validate_mac "${1}";
    then
        echo "${MAC} doesn't look like a valid MAC"
        return
    fi

    # Set it to lower case - easier to deal with
    local LOWER_MAC=$(echo ${MAC} | tr '[:upper:]' '[:lower:]')
    # Handle 1:0:5e:0:0:fb or dc:a6:32:d5:d6:8a
    local PADDED_MAC=""
    if [[ "${LOWER_MAC}" =~ ^[0-9a-f]{1,2}:[0-9a-f]{1,2}:[0-9a-f]{1,2}:[0-9a-f]{1,2}:[0-9a-f]{1,2}:[0-9a-f]{1,2} ]];
    then
        for bits in $(echo "${LOWER_MAC}" | awk -F ':' '{print $1, $2, $3, $4, $5, $6}')
        do
            if [[ "${bits}" =~ ^[0-9a-f]$ ]];
            then
                PADDED_MAC="${PADDED_MAC}0${bits}"
            else
                PADDED_MAC="${PADDED_MAC}${bits}"
            fi
        done
    # Handle 1-0-5e-0-0-fb or dc-a6-32-d5-d6-8a
    elif [[ "${LOWER_MAC}" =~ ^[0-9a-f]{1,2}-[0-9a-f]{1,2}-[0-9a-f]{1,2}-[0-9a-f]{1,2}-[0-9a-f]{1,2}-[0-9a-f]{1,2} ]];
    then
        for bits in $(echo "${LOWER_MAC}" | awk -F '-' '{print $1, $2, $3, $4, $5, $6}')
        do
            if [[ "${bits}" =~ ^[0-9a-f]$ ]];
            then
                PADDED_MAC="${PADDED_MAC}0${bits}"
            else
                PADDED_MAC="${PADDED_MAC}${bits}"
            fi
        done
    else
        # everything else (565e.f7a5.f8fd, 565ef7a5f8fd)
        PADDED_MAC="${LOWER_MAC}"
    fi

    # translate lowercase to uppercase, remove dots, print with colons between every 2 characters
    local CLEANMAC=$(echo "${PADDED_MAC}" | sed -e 's/ //g' -e 's/\.//g' -e 's/://g' | awk -F '' '{printf ("%s:%s:%s:%s:%s:%s", $1$2, $3$4, $5$6, $7$8, $9$10, $11$12)}')
    echo "${CLEANMAC}" | tr '[:lower:]' '[:upper:]'
}

oui_search () {
    local INPUT="${1}"
    local MAC=""
    local OUI=""

    if ! _has ip;
    then
        echo "iproute2 package not found."
        echo "This function requires the \"ip\" command."
        return
    fi

    # If it doesn't look like a valid MAC address, then try interface
    if ! validate_mac "${INPUT}";
    then
        MAC=$(ip addr show "${INPUT}" | grep -Eo "ether .*" | sed -e 's/ether//' -e 's/brd.*//' -e 's/ //g')
    else
        MAC=$(sanitize_mac "${INPUT}")
    fi

    MAC=$(echo $MAC | sed -e 's/:/-/g' | tr '[:lower:]' '[:upper:]')
    OUI="${MAC:0:8}"

    if ! [ -z "${OUI}" ];
    then
        curl --silent https://standards-oui.ieee.org/oui/oui.txt | grep "${OUI}"
    else
        echo "No MAC address supplied or an invalid interface was specified"
        return
    fi
}

# Find out if it's a valid IPv6 address
_is_ipv6 () {
    if ! _has ip;
    then
        echo "iproute2 package not found."
        echo "This function requires the \"ip\" command."
        return
    fi

    return $( eval ip -6 route get "${1}" >/dev/null 2>&1 )
}

# User-called function (echos to terminal)
is_ipv6() {
    if _is_ipv6 "${1}"
    then
        echo "${1} is a valid IPv6 address"
    else
        echo "${1} is NOT a valid IPv6 address"
    fi
}

# Find out if it's a valid IPv4 address
# On OSX, this is flawed because the iproute2mac package doesn't
# seem to respect the IPv4 address family and will happily show
# IPv6 routes
_is_ipv4 () {
    if ! _has ip;
    then
        echo "iproute2 package not found."
        echo "This function requires the \"ip\" command."
        return
    fi

    return $( eval ip -4 route get "${1}" >/dev/null 2>&1 )
}

# User-called function (echos to terminal)
is_ipv4() {
    if _is_ipv4 "${1}"
    then
        echo "${1} is a valid IPv4 address"
    else
        echo "${1} is NOT a valid IPv4 address"
    fi
}

# return nonzero unless $1 contains only digits
is_numeric() {
    case "$1" in
        "" | *[![:digit:]]* ) return 1;;
    esac
}

# return nonzero unless $1 contains only hexadecimal digits
is_hex() {
    case "$1" in
        "" | *[![:xdigit:]]* ) return 1;;
    esac
}

# Turn a MAC address into an EUI64 address
# optional second argument is IPv6 prefix (defaults to fe80:)
mac_to_eui64() {
    local MAC="${1}"
    local PREFIX="${2}"

    if [ -z "${MAC}" ];
    then
        echo "Must supply MAC address"
        return
    fi

    if ! validate_mac ${MAC};
    then
        echo "${MAC} doesn't look like a valid MAC address."
        return
    fi

    # Make sure we have a standardized MAC format
    CLEAN_MAC=$(sanitize_mac "${MAC}")

    # Default prefix if none is supplied
    if [ -z "${PREFIX}" ];
    then
        PREFIX="fe80:"
    else
        # Strip trailing ':' and '::/<whatever>'
        PREFIX=$(echo "${PREFIX}" | sed -e 's/:$//' -e 's/::\/[0-9][0-9]*$//')
    fi

    # get bits 7 and 8
    local FIRST=$(echo "${CLEAN_MAC}" | cut -d ':' -f 1)
    # Flip bit 7
    local NEWFIRST=$(printf %02x $((0x${FIRST} ^ 2)))
    # assemble the rest of the EUI64 string
    local EUI64=$(echo "${CLEAN_MAC}" | awk -F ':' '{print $2 ":" $3 "ff:fe" $4 ":" $5 $6}')
    # put it all together and make lowercase
    echo "${PREFIX}:${NEWFIRST}${EUI64}" | tr '[:upper:]' '[:lower:]'
}

expand_ipv6() {
    #if ! _has sipcalc;
    #then
    #    echo "please install sipcalc"
    #    return
    #fi
    #sipcalc -6 ${1} | grep Expanded | cut -d '-' -f 2 | sed -e 's/ //g'
    echo ${1} | awk '{if(NF<8){inner = "0"; for(missing = (8 - NF);missing>0;--missing){inner = inner ":0"}; if($2 == ""){$2 = inner} else if($3 == ""){$3 = inner} else if($4 == ""){$4 = inner} else if($5 == ""){$5 = inner} else if($6 == ""){$6 = inner} else if($7 == ""){$7 = inner}}; print $0}' FS=":" OFS=":" | awk '{for(i=1;i<9;++i){len = length($(i)); if(len < 1){$(i) = "0000"} else if(len < 2){$(i) = "000" $(i)} else if(len < 3){$(i) = "00" $(i)} else if(len < 4){$(i) = "0" $(i)} }; print $0}' FS=":" OFS=":"
}

export BAT_THEME="Dracula"
export VIRTUAL_ENV_DISABLE_PROMPT="yes"

# add pipx to path if it's installed
if [ -d "${HOME}/.local/bin" ]; then
    export PATH="${HOME}/.local/bin:$PATH"
fi

## Import machine-specific settings if available
if [ -e ~/.zshrc_local ]; then
  source ~/.zshrc_local
fi

if _has fastfetch; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS - use mount and filter
        mount_list=$(mount | awk '$1 ~ /^\/dev\// || $1 ~ /^[^\/].*:/ {print $3}' | tr '\n' ':' | sed 's/:$//')
    else
        # Linux - use /proc/mounts
        mount_list=$(awk '$3 ~ /^(ext[234]|xfs|btrfs|nfs|nfs4|cifs|vfat|ntfs|f2fs|zfs)$/ {print $2}' /proc/mounts | tr '\n' ':' | sed 's/:$//')
    fi

    #echo "$mount_list"

    fastfetch --gen-config-force 2>&1 >/dev/null

    ## Overwrite the "disk" module to show the disks that we want to display
    # should look like
    # { "type": "disk", "folders": "/mnt/nfs/to_transcode:/mnt/nfs/raw:/mnt/nfs/transcode_complete:/mnt/nfs/plex"}
    # when we're done

    CONFIG_FILE="$HOME/.config/fastfetch/config.jsonc"

    # Escape special characters in mount_list for use in sed
    # Replace backslashes, forward slashes, ampersands, and quotes
    escaped_mount_list=$(echo "${mount_list}" | sed 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g; s/"/\\"/g')

    # Replace the "disk" string with the disk module object
    # Use gsed on macOS if available, otherwise use sed with appropriate syntax
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v gsed &> /dev/null; then
            gsed -i "s/\"disk\"/{ \"type\": \"disk\", \"folders\": \"${escaped_mount_list}\" }/g" "${CONFIG_FILE}"
        else
            sed -i '' "s/\"disk\"/{ \"type\": \"disk\", \"folders\": \"${escaped_mount_list}\" }/g" "${CONFIG_FILE}"
        fi
    else
        sed -i "s/\"disk\"/{ \"type\": \"disk\", \"folders\": \"${escaped_mount_list}\" }/g" "${CONFIG_FILE}"
    fi
    fastfetch
fi