#!/bin/bash
# author wangyingbo

# 更新路径
UPDATE_URL='https://itunes.apple.com/cn/app/id1315485432'
# 自增数字
UPDATE_INCREASE=0
# 更新类型 1强更 0不强更
UPDATE_TYPE=1
# 日期
UPDATE_DATE=`date +%Y%m%d`
# 平台
PLATFORM='B'
# 系统 Android是3，iOS是2
SYSTEM=2
# iOS是否要pop弹窗
UPDATE_POP=1



# 缓存文件路径
CACHE_PATH=./caches



echo -e "\n"
while [[ -z $VERSION ]]; do
	echo -e "\033[33;40m 请输入版本号 \033[0m"
	read versionFloat
	VERSION=$versionFloat
	echo -e "\033[32;40m 输入的版本号是：${VERSION} \033[0m"
done

echo -e "\n"
while [[ -z $DESCRIPTION ]]; do
	echo -e "\033[33;40m 请输入更新描述 \033[0m"
	read des
	DESCRIPTION=$des
	echo -e "\033[32;40m 输入的更新描述是：${DESCRIPTION} \033[0m"
done


get_increase_number() {
	if [[ -e ${CACHE_PATH}/increase.data ]]; then
		NUM=$(tail -n 1 ${CACHE_PATH}/increase.data)
		return $NUM
	else 
		echo -e "\033[31;40m error: increase.data 不存在！！ \033[0m"
		echo "" >> ${CACHE_PATH}/increase.data
	fi
}


echo -e "\n"
# echo "更新路径是：${UPDATE_URL}"
echo "更新日期是：${UPDATE_DATE}"


get_increase_number
resIncrease=`echo $?`
echo "缓存的自增数字是：${resIncrease}"
resIncrease=$((${resIncrease}+1))
echo $resIncrease >> ${CACHE_PATH}/increase.data
get_increase_number
UPDATE_INCREASE=`echo $?`
echo "最终的自增数字是：${resIncrease}"


olduuid=`uuidgen`
echo "生成的uuid是：${olduuid}"
uuid=$(echo $olduuid | tr -d "-")
echo "最后的uuid是：${uuid}"


result="insert into fbappsvr.sys_apk_config (APK_ID, VERSION_CODE, DOWNLOAD_LINK, UPDATE_DESC, GRADE, IS_FORCE_UPDATE, CREATER, CREATE_TM, APP_FLAG, APP_PLAT, IS_POP, MD5)
values ('${uuid}', '${VERSION}', '${UPDATE_URL}', '${DESCRIPTION}', ${UPDATE_INCREASE}, '${UPDATE_TYPE}', '', '${UPDATE_DATE}', '${PLATFORM}', '${SYSTEM}', '${UPDATE_POP}', '')"


echo -e "\n"
echo -e "\033[32;40m ${result}  \033[0m"
echo $result | pbcopy


echo -e "\n"
echo -e "\033[32;40m this shell script execution duration(脚本执行时长): ${SECONDS}s  \033[0m"

