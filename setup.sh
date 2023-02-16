#!/usr/bin/env zsh

set -euo pipefail

DEBIAN=0
OSX=0

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

if ! [[ $(grep "fzf" ~/.vimrc_local) ]];
then
    /bin/cat .vimrc_local | sed -e "s,FZF_PLACEHOLDER,${FZF}," >> ~/.vimrc_local
fi

if ! [[ -d ~/.vim/bundle/Vundle.vim ]];
then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim && vim +PluginInstall +qall
fi

echo "Please re-launch your shell with 'exec zsh'"