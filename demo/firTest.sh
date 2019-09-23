#!/bin/bash
# author wangyingbo

FIR_TOKEN="78fdc5d7d05495979153badec808e6e5"

# 判断fir-cli命令是否可用
isExitFir() {
	para=0
	files=$(command -v fir)
	if [ $files ] ; then
		para=1
	else
		echo -e "\033[31;40m warning: 请先安装fir命令!!! \033[0m"
		cat <<EOF
		请先安装fir命令:
			sudo gem install fir-cli
			或
			sudo gem install -n /usr/local/bin fir-cli
EOF
	fi
	return $para
}

res1=$(isExitFir)
res2=`echo $?`

if [[ $res2 -eq 0 ]]; then
	echo -e "\033[31;40m 没有安装fir \033[0m"
	exit 0
else
	echo -e "\033[33;40m 正在使用fir上传... \033[0m"
	if [[ -z $FIR_TOKEN ]]; then
		echo -e "\033[31;40m fir token is null!! \033[0m"
		exit 0
	fi

	fir login -T $FIR_TOKEN       # fir.im token
	result=$(fir publish /Users/fengbang/Desktop/edianzu_20190923154116.ipa/edianzu.ipa)
	echo -e "\033[33;40m  \nfir上传结果\n  \033[0m"
	echo -e "  $result  "
fi



echo -e "这是最后执行的一行"
