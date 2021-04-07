####################
#Dot loader for ZSH#
####################

ZSHHOME="${HOME}/.zsh/env"

if [ -d $ZSHHOME -a -r $ZSHHOME -a -x $ZSHHOME ]; then
	for i in $ZSHHOME/*; do
		[[ ${i##*/} = *.zsh ]] &&
		[ \( -f $i -o -h $i \) -a -r $i ] && source $i
	done
fi

