#!/usr/bin/env zsh

# requirements
REQUIREMENTS=(fzf fd zsh git vim)

function _has () {
	return $( whence -p $1 &>/dev/null )
}

FAIL=0

for program in ${(@)REQUIREMENTS};
do
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

git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
cp fino-time-dwa.zsh-theme ~/.oh-my-zsh/custom/themes
exec zsh
FZF=$(which fzf)
cp ~/.vimrc_local ~/.vimrc_local.bak
/bin/cat .vimrc_local | sed -e "s/FZF_PLACEHOLDER/${FZF}/" ~/.vimrc_local
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim && vim +PluginInstall +qall
