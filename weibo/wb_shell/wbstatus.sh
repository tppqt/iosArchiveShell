#!/bin/sh

cd `dirname $0`
root=`pwd`

red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5) #浅红
cyan=$(tput setaf 6) #青色
white=$(tput setaf 7) #白色
reverse=$(tput rev)
reset=$(tput sgr0)

show_all_detail=false

usage()
{
cat << EOF
usage: $0 options

This script shows every subproject’s status detail.

OPTIONS:
   -a      Force to show all detail.
   		example:  ./status -a

EOF
}

while getopts ":a" OPTION
do
     case $OPTION in
         a)
	   show_all_detail=true
            ;;
         ?)
 	    echo "Unknown option $OPTARG"
            exit
            ;;
     esac
done
			

echo ${blue}"Here are the statuses below after you run the add script："${reset}
current_branch=`git branch | grep \* | awk '{print $2}'`
hasDiff=`git status -s`
if [[ -n ${hasDiff} ]]; then
	current_branch=`git branch | grep \* | awk '{print $2}'`
	current_repo_info=`git status | grep 'Your branch'`
	echo ${blue}MainRepo[${red}${current_branch}${blue}]${reset}:
	printf "${current_repo_info}\n${hasDiff}\n"
fi

echo

cat external_sources | while read ext_source_config || [[ -n "$ext_source_config" ]]; do
	if [[ -n $ext_source_config ]]; then
		ext_source_path=`echo ${ext_source_config} | awk '{print $1}'`			# Subprojects/WBTool
		ext_source_branch=`echo ${ext_source_config} | awk '{print $2}'`				# head
		ext_source_repo_path=`echo ${ext_source_config} | awk '{print $3}'`			# http://svn....

		if [[ -d ${ext_source_path} ]]; then
			cd ${ext_source_path}; 

			hasDiff=`git status -s`

			if [[ -n ${hasDiff} ]]|| ${show_all_detail}; then
				current_branch=`git branch | grep \* | awk '{print $2}'`
				current_repo_info=`git status | grep 'Your branch'`
				echo ${blue}${ext_source_path}[${red}${current_branch}${blue}]${reset}:
				printf "${current_repo_info}\n${hasDiff}\n"

			fi
			
			cd ${root};
		fi
	fi
done

