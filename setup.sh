#!/usr/bin/env zsh

set -euo pipefail

DEBIAN=0
OSX=0
INSTALL=0
PARAMS=""

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
        -d|--dotfiles)
            INSTALL=1
            shift
            ;;
        --debug)
            set -x
            shift
            ;;
        -*|--*=) # unsupported flags
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

# requirements
REQUIREMENTS=(fzf fd zsh git vim)

function _has () {
	return $( whence -p $1 &>/dev/null )
}

FAIL=0

for program in ${(@)REQUIREMENTS};
do
    if [[ ${DEBIAN} = 1 ]] && [[ ${program} =~ "fd" ]];
    then
        program="fdfind"
    fi

    # lazy attempt to install
    if ! _has "${program}" && [[ ${DEBIAN} = 1 ]];
    then
        if [[ ${program} =~ "fdfind" ]];
        then
            sudo apt install -y fd-find
        else
            sudo apt install -y ${program}
        fi
    elif ! _has "${program}" && [[ ${OSX} = 1 ]];
    then
        brew install ${program}
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

if ! [[ -d ~/.oh-my-zsh ]];
then
    git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
fi

if ! [[ -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]];
then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
fi

if ! [[ -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]];
then
    git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
fi

install -b -C fino-time-dwa.zsh-theme ~/.oh-my-zsh/custom/themes
FZF=$(whence -p fzf)

# stupid hack to make sure the file exists
if ! [[ -f ~/.vimrc_local ]];
then
    touch ~/.vimrc_local
fi

if ! [[ $(grep "fzf" ~/.vimrc_local) ]];
then
    /bin/cat .vimrc_local | sed -e "s,FZF_PLACEHOLDER,${FZF}," >> ~/.vimrc_local
fi

if ! [[ -d ~/.vim/bundle/Vundle.vim ]];
then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim && vim +PluginInstall +qall
fi

if [[ ${INSTALL} = 1 ]];
then
    FILES=(.fdignore .vimrc .tmux.conf .zshrc)
    for file in ${(@)FILES};
    do
        ln -sf ${PWD}/${file} ~/${file}
    done
fi

echo "Please re-launch your shell with 'exec zsh'"