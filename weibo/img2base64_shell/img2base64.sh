#!/bin/bash
# author wangyingbo
# date:2021-04-08 下午 11:30

FORMATTER='txt'
SUFFIX=.${FORMATTER}
DATE=`date +%Y%m%d%H%M%S`
TIME=$(date "+%Y-%m-%d %H:%M:%S")

# 转码base64
base64Func() {
	param=$1
	if [ -d $param ]; then
		# 目录类型，递归遍历
		echo ""
		for file in $param/*; do
    		# echo $file
    		OLD_IFS="$IFS"
			IFS="."
			array=($file)
			IFS="$OLD_IFS"
			suffixStr=${array[${#array[@]}-1]}
			if [[ $suffixStr != $FORMATTER ]]; then
    			base64Func $file
			fi
		done
	else
		OLD_IFS="$IFS"
		IFS="."
		array=($param)
		IFS="$OLD_IFS"
		# echo ${#array[@]}
		unset 'array[${#array[@]}-1]'
		# echo $array
		for var in ${array[@]}
		do
  			# echo $var
  			echo ""
		done

		OLD_IFS="$IFS"
		IFS="/"
		preArray=($var)
		IFS="$OLD_IFS"
		# echo ${#preArray[@]}
		fileName=${preArray[${#preArray[@]}-1]}
		unset 'preArray[${#preArray[@]}-1]'
		prePath=''
		for per in ${preArray[@]}
		do
  			# echo $per
  			prePath=$prePath/$per
		done
		# echo $prePath
		# echo $fileName
		res=`cat $param | base64`
		outPath=$prePath/$fileName$SUFFIX
		echo $res >> $outPath
		echo -e "\033[32;40m success:  ${outPath} \033[0m"
		echo ""
	fi
}


base64Func $1

# shell excute time
echo -e "\033[33;40m  ($0) ${TIME}: this shell script execution duration: ${SECONDS}s  \033[0m"
echo ""



