#!/bin/bash
# author wangyingbo

if [ -d "dist" ] ; then
	echo -e "\033[32;40m ***-------------拷贝dist目录并生成项目文件夹----------------*** \033[0m"
else
	echo -e "\033[31;40m ***-------------当前不存在dist文件夹----------------*** \033[0m"
	exit 0
fi