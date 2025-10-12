#!/usr/bin/env bash

set -euo pipefail

DEBIAN=0
OSX=0
LINK_DOTFILES=0
PARAMS=""
SETUP_VIM=0
SETUP_ZSH=0
INSTALL_REQUIREMENTS=0
DRYRUN=0
# requirements
REQUIREMENTS=(fzf fd zsh git vim)
FAIL=0

# Show help message
function usage() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help                   Show this help message and exit"
    echo "  -l, --link                   Link dotfiles (creates symlinks in home directory)"
    echo "  -a, --all                    Run all setup steps (requirements, vim, zsh, link)"
    echo "  -r, --install-requirements   Install required packages (fzf, fd, zsh, git, vim)"
    echo "  -v, --setup-vim              Setup vim and plugins"
    echo "  -z, --setup--zsh             Setup zsh and plugins"
    echo "      --debug                  Enable debug mode"
    echo "      --dryrun, --dry-run      Show what would be done, but do not actually do it"
    echo ""
    echo "This script sets up a shell environment by installing necessary tools,"
    echo "configuring zsh and vim, and linking dotfiles. It supports Debian-based systems and macOS."
}

# Check to see if a program is installed
function _has() {
    # shellcheck disable=SC2046
	return $(which -s "${1}")
}

function mycopy() {
    src="${1}"
    dest="${2}"
    # use install if available, otherwise fall back to cp
    if ! install -b -C "${src}" "${dest}"; then
        cp "${dest}" "${dest}.bak"
        cp "${src}" "${dest}"
    fi
}

# Setup vim with Vundle and plugins
function setup_vim() {
    FZF=$(which fzf)

    # stupid hack to make sure the file exists
    if ! [[ -f ~/.vimrc_local ]];
    then
        if [[ ${DRYRUN} = 1 ]]; then
            echo "touch ~/.vimrc_local"
        else
            touch ~/.vimrc_local
        fi
    fi

    # update fzf settings in .vimrc_local
    if ! grep -q "fzf" ~/.vimrc_local;
    then
        if [[ ${DEBIAN} = 1 ]];
        then
            if [[ ${DRYRUN} = 1 ]]; then
                echo "echo 'source /usr/share/doc/fzf/examples/fzf.vim' >> ~/.vimrc_local"
            else
                echo "source /usr/share/doc/fzf/examples/fzf.vim" >> ~/.vimrc_local
            fi
        fi
        if [[ ${DRYRUN} = 1 ]]; then
            echo "/bin/cat .vimrc_local | sed -e 's,FZF_PLACEHOLDER,${FZF},' >> ~/.vimrc_local"
        else
            /bin/cat .vimrc_local | sed -e "s,FZF_PLACEHOLDER,${FZF}," >> ~/.vimrc_local
        fi
    fi

    # Set up vundle and plugins
    if ! [[ -d ~/.vim/bundle/Vundle.vim ]];
    then
        if [[ ${DRYRUN} = 1 ]]; then
            echo "git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim && vim +PluginInstall +qall"
        else
            git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim && vim +PluginInstall +qall
        fi
    fi

    # Set up vim color scheme
    if ! [[ -d ~/.vim/colors ]];
    then
        if [[ ${DRYRUN} = 1 ]]; then
            echo "mkdir ~/.vim/colors"
            echo "cp elflord_old.vim ~/.vim/colors"
        else
            mkdir ~/.vim/colors
            mycopy elflord_old.vim ~/.vim/colors
        fi
    fi
}

# Check the OS type
function check_os() {
    if [[ -f /etc/debian_version ]];
    then
        DEBIAN=1
    fi

    if [[ $(uname) =~ "Darwin" ]];
    then
        OSX=1
    fi

    if [[ ${DEBIAN} = 0 ]] && [[ ${OSX} = 0 ]];
    then
        echo "Unknown target system; this script may not work correctly"
    fi
}

# Check and install requirements
function install_requirements() {
    for program in "${REQUIREMENTS[@]}";
    do
        # hack because debian calls the program fdfind
        if [[ ${DEBIAN} = 1 ]] && [[ ${program} =~ "fd" ]];
        then
            program="fdfind"
        fi

        # lazy attempt to install
        if ! _has "${program}" && [[ ${DEBIAN} = 1 ]];
        then
            if [[ ${program} =~ "fdfind" ]];
            then
                if [[ ${DRYRUN} = 1 ]] || [[ ${INSTALL_REQUIREMENTS} = 0 ]]; then
                    echo "sudo apt install -y fd-find"
                else
                    sudo apt install -y fd-find
                fi
            else
                if [[ ${DRYRUN} = 1 ]] || [[ ${INSTALL_REQUIREMENTS} = 0 ]]; then
                    echo "sudo apt install -y ${program}"
                else
                    sudo apt install -y "${program}"
                fi
            fi
        elif ! _has "${program}" && [[ ${OSX} = 1 ]];
        then
            if [[ ${DRYRUN} = 1 ]] || [[ ${INSTALL_REQUIREMENTS} = 0 ]]; then
                echo "brew install ${program}"
            else
                brew install "${program}"
            fi
        fi

        if ! _has "${program}";
        then
            echo "${program} not found"
            FAIL=1
        else
            echo "${program} OK"
        fi
    done

    if [[ "${FAIL}" -eq 1 ]];
    then
        echo "Please install missing programs before re-running this script"
        exit 1
    fi
}

# Setup zsh with oh-my-zsh and plugins
function setup_zsh() {
    if ! [[ -d ~/.oh-my-zsh ]];
    then
        if [[ ${DRYRUN} = 1 ]]; then
            echo "git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh"
        else
            git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
        fi
    fi

    if ! [[ -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]];
    then
        if [[ ${DRYRUN} = 1 ]]; then
            echo "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
        else
            git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
        fi
    fi

    if ! [[ -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]];
    then
        if [[ ${DRYRUN} = 1 ]]; then
            echo "git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
        else
            git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
        fi
    fi

    if [[ ${DRYRUN} = 1 ]]; then
        echo "install -b -C fino-time-dwa.zsh-theme ~/.oh-my-zsh/custom/themes"
    else
        mycopy fino-time-dwa.zsh-theme ~/.oh-my-zsh/custom/themes
    fi
}

# Link dotfiles to home directory
function link_dotfiles() {
    # check for GNU ln
    if _has gln;
    then
        LN="gln"
    else
        LN="ln"
    fi
    FILES=(.fdignore .vimrc .tmux.conf .zshrc)
    for file in "${FILES[@]}";
    do
        if [[ ${DRYRUN} = 1 ]]; then
            echo "${LN} -sfr ${file} ~/${file}"
        else
            ${LN} -sfr "${file}" ~/"${file}"
        fi
    done

    if _has bat;
    then
        if [[ ${DRYRUN} = 1 ]]; then
            echo "${LN} -sfr bat_config $(bat --config-file)"
        else
            ${LN} -sfr bat_config "$(bat --config-file)";
        fi
    fi
}

# Parse arguments
while (( $# ));
do
    case "$1" in
        --) # end argument parsing
            shift
            break
            ;;
        -h|--help)
            usage
            exit
            ;;
        -l|--link)
            LINK_DOTFILES=1
            shift
            ;;
        -a|--all)
            INSTALL_REQUIREMENTS=1
            SETUP_VIM=1
            SETUP_ZSH=1
            LINK_DOTFILES=1
            shift
            ;;
        --debug)
            set -x
            shift
            ;;
        -r|--install-requirements)
            INSTALL_REQUIREMENTS=1
            shift
            ;;
        --dryrun|--dry-run)
            DRYRUN=1
            shift
            ;;
        -z|--setup--zsh)
            SETUP_ZSH=1
            shift
            ;;
        -v|--setup-vim)
            SETUP_VIM=1
            shift
            ;;
        --*=|-*) # unsupported flags
            echo "Error: unsupported flag $1" >&2
            exit 2
            ;;
        *) # Preserve positional arguments
            PARAMS="$PARAMS $1"
            shift
            ;;
    esac
done

# Set positional arguments in their proper place
eval set -- "$PARAMS"

check_os
install_requirements # kind of a misnomer since it'll only install if asked

if [[ ${SETUP_VIM} = 1 ]]; then
    setup_vim
fi

if [[ ${SETUP_ZSH} = 1 ]]; then
    setup_zsh
fi

if [[ ${LINK_DOTFILES} = 1 ]]; then
    link_dotfiles
fi

if [[ ${SETUP_ZSH} = 1 ]] || [[ ${LINK_DOTFILES} = 1 ]]; then
    echo "Please re-launch your shell with 'exec zsh'"
fi
