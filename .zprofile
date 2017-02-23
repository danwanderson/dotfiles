# /etc/skel/.bash_profile:
# $Header: /home/cvsroot/gentoo-src/rc-scripts/etc/skel/.bash_profile,v 1.10 2002/11/18 19:39:22 azarah Exp $

#export PATH=/opt/local/bin:/opt/local/sbin:$PATH:$HOME/bin:/usr/local/bin:$HOME/bin/routers:$HOME/bin/lab_routers
#export CVSROOT=/opt/cvsroot
#export EDITOR=/usr/bin/vim

#This file is sourced by bash when you log in interactively.
[ -f ~/.zshrc ] && . ~/.zshrc

# Remove minicom's log files
rm -f $HOME/minicom.log

# Remove Cisco PIX PDM cache
rm -rf $HOME/pdmcache

#echo "Current System Status:"
#echo ""
#uptime
#echo ""
