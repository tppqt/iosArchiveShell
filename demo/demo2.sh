#!/bin/bash
# author wangyingbo


files=$(ls *.php 2> /dev/null | wc -l)
# echo -e "${files}"

phpFile=$(ls *.php)
# echo -e "${phpFile}"

# cat ${phpFile}

# 获取当前仓库路径
# remoteUrl=$(git remote -v)
# echo -e "当前仓库路径是：${remoteUrl}"


fool(){
	echo -e "some thing happend!"
}

cool(){
	echo -e "i love you!"
}

echo -e "请输入1或者2\n"
read method
if [[ $method -eq 1 ]]; then
	fool
elif [[ $method -eq 2 ]]; then
	cool
else
	echo -e "\033[31;40m warning: 请输入正确的值! \033[0m"
fi

