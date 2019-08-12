#!/bin/bash
# author wangyingbo


# 定义变量
MODE=""
METHOD=""
IS_WORKSPACE=false
UPLOAD_TYPE=0


# 输入打包模式，debug:0, release:1 （输出颜色配置：https://www.cnblogs.com/-beyond/p/8242820.html）
while [[ -z $MODE ]]; do
	echo -e "\033[33;40m 请输入打包模式：debug:0, release:1 \033[0m"
	read modeInt
	echo -e "\033[32;40m 输入的模式值是：${modeInt} \033[0m"
	# echo "shell脚本名称: $0"
	if [ $modeInt -eq 1 ] ; then
		MODE="Release"
	elif [ $modeInt -eq 0 ] ; then
		MODE="Debug"
	else
		echo -e "\033[31;40m warning: 请输入正确的模式：0或1 \033[0m"
		# exit 1
	fi
done
echo -e "\033[32;40m 当前选择的打包模式为：${MODE} \033[0m"


# 输入打包环境 方式分别为 development:0, ad-hoc:1, app-store:2, enterprise:3 。必填
echo -e "\n"
while [[ -z $METHOD ]]; do
	echo -e "\033[33;40m 请输入打包方式：development:0, ad-hoc:1, app-store:2, enterprise:3 \033[0m"
	read methodInt
	echo -e "\033[32;40m 输入的打包方式值是：${methodInt} \033[0m"
	if [[ $methodInt -eq 0 ]]; then
		METHOD="development"
	elif [[ $methodInt -eq 1 ]]; then
		METHOD="ad-hoc"
	elif [[ $methodInt -eq 2 ]]; then
		METHOD="app-store"
	elif [[ $methodInt -eq 3 ]]; then
		METHOD="enterprise"
	else
		echo -e "\033[31;40m warning: 请输入正确的打包方式：development:0, ad-hoc:1, app-store:2, enterprise:3 \033[0m"
	fi
done
echo -e "\033[32;40m 当前选择的打包方式为：${METHOD} \033[0m"


# 是否编译工作空间(例:若是用Cocopods管理的.xcworkspace项目,赋值true;用Xcode默认创建的.xcodeproj,赋值false)
echo -e "\n" # .xcworkspace
files=$(ls *.xcworkspace 2> /dev/null | wc -l) # 判断目录下是否存在已知后缀名文件
if [ $files -ne 0 ] ; then #判断某扩展名文件是否存在 if ls *.xcworkspace >/dev/null 2>&1; then 
	IS_WORKSPACE=true
else
	IS_WORKSPACE=false
fi
echo -e "\033[32;40m 当前目录是否包含.xcworkspace：${IS_WORKSPACE} \033[0m"


# 是否上传
echo -e "\n"
echo -e "\033[33;40m 请输入上传方式：0不上传；1：蒲公英；2：fir \033[0m"
read UPLOAD_TYPE
echo -e "\033[32;40m 选择的上传渠道为：${UPLOAD_TYPE} \033[0m"

