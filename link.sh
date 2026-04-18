#!/usr/bin/env bash
files=""
backup="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$backup"
for i in  */
do 
    if [ -d $i/.config ]
        then 
	    files="$files $HOME/.config/${i%?}"
	elif [ -d $i/.local/share ];then
	    files="$files $HOME/.local/share/${i%?}"
	#elif [ -d $i/.local/bin ];then
	#    files="$files $HOME/.local/bin/${i%?}"
        else 
	    files="$files $HOME/.${i%?}"
    fi
done

echo -e "\e[31m"
echo $files | sed -e "s/ /\n/g" 
echo -e "\e[0m"
echo "Reblace All Files [N,y] ?"
read answer
if [[ $answer == "y" ]] || [[ $answer == "Y" ]];then
	for i in $files;do
		if [ -e "$i" ]; then
              		echo "Moving $i to $backup"
            		mv -f "$i" "$backup"
        	fi
	done
	stow -t "$HOME" */
fi
