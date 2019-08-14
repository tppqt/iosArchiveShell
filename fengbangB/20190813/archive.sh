#!/bin/bash
# author wangyingbo



# 定义一些通用参数（根据配置修改）
# scheme name, 可以用xcodebuild -list命令查看schemename
SCHEMENAME="FengbangB"
# Debug 或者 Release
MODE=''
# method，打包的方式。方式分别为 development, ad-hoc, app-store, enterprise 。必填
METHOD=""
# 是否编译工作空间(例:若是用Cocopods管理的.xcworkspace项目,赋值true;用Xcode默认创建的.xcodeproj,赋值false)
IS_WORKSPACE="true"


# 上传方式：0：不上传；1：蒲公英；2：fir；
UPLOAD_TYPE=
#蒲公英apiKey
MY_PGY_API_K="652ed9b22548860042836f8129474dc9"
#蒲公英userKey
MY_PGY_UK="68254eed28f1286cb113b7b6e25b159e"


# 定义路径
WORKSPACE=${SCHEMENAME}.xcworkspace
DATE=`date +%Y%m%d%H%M%S`
CACHEPATH=~/Desktop/derivedData
ARCHIVEPATH=~/Desktop/derivedData/${SCHEMENAME}.xcarchive
IPAPATH=~/Desktop
IPANAME=${SCHEMENAME}_$DATE.ipa
EXPORT_OPTIONS_PLIST_PATH=~/Desktop/derivedData/ExportOptions.plist
# 下面两个参数只是在手动指定Pofile文件的时候用到，如果使用Xcode自动管理Profile,直接留空就好
# (跟method对应的)mobileprovision文件名，需要先双击安装.mobileprovision文件.手动管理Profile时必填
MOBILEPROVISION_NAME=""
# 项目的bundleID，手动管理Profile时必填
BUNDLE_IDENTIFIER=""



# *****************************输入配置项*****************************

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
if [[ -z $IS_WORKSPACE ]]; then
	echo -e "\033[33;40m 判断某扩展名文件是否存在 \033[0m"
	files=$(ls *.xcworkspace 2> /dev/null | wc -l) # 判断目录下是否存在已知后缀名文件
	if [ $files -ne 0 ] ; then #判断某扩展名文件是否存在 if ls *.xcworkspace >/dev/null 2>&1; then 
		IS_WORKSPACE=true
	else
		IS_WORKSPACE=false
	fi
fi
echo -e "\033[32;40m 当前目录是否包含.xcworkspace：${IS_WORKSPACE} \033[0m"


# 是否上传
echo -e "\n"
while [[ -z $UPLOAD_TYPE ]]; do
	echo -e "\033[33;40m 请输入上传方式：0：不上传；1：蒲公英；2：fir \033[0m"
	read UPLOAD_TYPE
done
echo -e "\033[32;40m 选择的上传渠道为(0：不上传；1：蒲公英；2：fir)：${UPLOAD_TYPE} \033[0m"



# *****************************用xcodebuild archive打包*****************************

# xcodebuild archive 打包
# 如果有workspace则需要加参数 -workspace $WORKSPACE
if $IS_WORKSPACE ; then
	xcodebuild archive -workspace ${WORKSPACE} -scheme ${SCHEMENAME} -configuration $MODE clean build -archivePath $ARCHIVEPATH
else
	xcodebuild archive -scheme ${SCHEMENAME} -configuration $MODE clean build -archivePath $ARCHIVEPATH
fi

# 根据参数生成export_options_plist文件
/usr/libexec/PlistBuddy -c  "Add :method String ${METHOD}"  $EXPORT_OPTIONS_PLIST_PATH
/usr/libexec/PlistBuddy -c  "Add :provisioningProfiles:"  $EXPORT_OPTIONS_PLIST_PATH
/usr/libexec/PlistBuddy -c  "Add :provisioningProfiles:${BUNDLE_IDENTIFIER} String ${MOBILEPROVISION_NAME}"  $EXPORT_OPTIONS_PLIST_PATH

# xcodebuild -exportArchive必须需要 -exportOptionsPlist参数，把路径写上去
xcodebuild -exportArchive -archivePath $ARCHIVEPATH -exportOptionsPlist ${EXPORT_OPTIONS_PLIST_PATH} -exportPath $IPAPATH/$IPANAME -allowProvisioningUpdates

if [ -e $IPAPATH/$IPANAME ]; then
	# 黄色文字 echo -e "\033[33;40m  \033[0m"
	# 绿色文字 echo -e "\033[32;40m  \033[0m"
	echo -e "\033[32;40m ***-----------------------------*** \033[0m"
	echo -e "\033[32;40m  build successful! Configurations! \033[0m"
	echo -e "\033[32;40m ***-----------------------------*** \033[0m"
	# git status
else
	# 红色红字 echo -e "\033[31;40m warning: \033[0m"
	echo -e "\033[31;40m ***-----------------------------*** \033[0m"
	echo -e "\033[31;40m      error:create IPA failed! \033[0m"
	echo -e "\033[31;40m ***-----------------------------*** \033[0m"
fi

# 判断上传方式
if [ ${UPLOAD_TYPE} == 1 ]; then
	#蒲公英
	echo -e "\n"
	echo -e "\033[33;40m begin upload to pgyer... \033[0m"
	echo -e "\n"
    curl -F "file=@${IPAPATH}/${IPANAME}/${SCHEMENAME}.ipa" -F "uKey=${MY_PGY_UK}" -F "_api_key=${MY_PGY_API_K}" https://qiniu-storage.pgyer.com/apiv1/app/upload
    echo -e "\n"
    echo -e "\033[32;40m upload successful! \033[0m"
	echo -e "\n"
elif [[ ${UPLOAD_TYPE} == 2 ]]; then
   	#fir
	echo -e "\n"
	echo -e "\033[33;40m waiting upload to fir... \033[0m"
   	echo -e "\n"
else
	echo -e "\n"
	echo -e "\033[32;40m please upload by hand! \033[0m"
	echo -e "\n"
fi

# delete ARCHIVEPATH file
if [ -e $ARCHIVEPATH ]; then
	rm -rf $ARCHIVEPATH
	if [ $? -ne 0 ]; then
		echo -e "\033[31;40m error: delete archivePath failed! \033[0m"
		exit 1
	fi
fi

# delete EXPORT_OPTIONS_PLIST_PATH file
if [ -e $EXPORT_OPTIONS_PLIST_PATH ]; then
	rm -rf $EXPORT_OPTIONS_PLIST_PATH
	if [ $? -ne 0 ]; then
		echo -e "\033[31;40m error: delete exprot options plist path failed! \033[0m"
		exit 1
	fi
fi

# delete derivedData
if [ -e $CACHEPATH ]; then
	#mv $CACHEPATH ~/.Trash
	rm -rf $CACHEPATH
	if [ $? -ne 0 ]; then
		echo -e "\033[31;40m error: delete trash files failed! \033[0m"
		exit 1
	fi
fi



# *****************************用xcodebuild和xcrun打包*****************************

# # xcodebuild 
# # 如果有workspace则需要加参数 -workspace $WORKSPACE
# xcodebuild \
#  -workspace $WORKSPACE \
#  -scheme ${SCHEMENAME} \
#  -configuration $MODE \
#  clean \
#  build \
#  -derivedDataPath $CACHEPATH

# # xcrun打包 - 用PackageApplication工具打包。
# # 打包找不到 "PackageApplication" 文件, https://blog.csdn.net/qq_19484963/article/details/79094554
# # warning: PackageApplication is deprecated, use `xcodebuild -exportArchive` instead
# xcrun \
#  -sdk iphoneos PackageApplication \
#  -v $CACHEPATH/Build/Products/Debug-iphoneos/${SCHEMENAME}.app \
#  -o $IPAPATH/$IPANAME


# if [ -e $IPAPATH/$IPANAME ]; then
# 	echo "***---------------------***"
# 	echo "build successful! Configurations!"
# 	echo "***---------------------***"
# 	git status
# 	#git log -2
# 	#open $IPAPATH
# else
# 	echo "***---------------------***"
# 	echo "error:create IPA failed!"
# 	echo "***---------------------***"
# fi

# # delete derivedData
# if [ -e $CACHEPATH ]; then
# 	#mv $CACHEPATH ~/.Trash
# 	rm -rf $CACHEPATH
# 	if [ $? -ne 0 ]; then
# 		echo "error: delete trash files failed!"
# 		exit 1
# 	fi
# fi



# 输出打包总用时
echo -e "\033[32;40m this shell script execution duration(脚本执行时长): ${SECONDS}s  \033[0m"


