#!/bin/bash
# author wangyingbo


ls
echo "test a fool"


files=$(ls fengbangb_web 2> /dev/null | wc -l) 
if [ $files -ne 0 ] ; then 
	echo -e "\033[32;40m ***-------------删除旧项目----------------*** \033[0m"
	# rm -rf fengbangb_web
fi