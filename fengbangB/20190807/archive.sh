#!/bin/bash
# author wangyingbo



# 定义一些通用参数（根据配置修改）
# scheme name, 可以用xcodebuild -list命令查看
SCHEMENAME="FengbangB"
# Debug 或者 Release
MODE='Debug'
# method，打包的方式。方式分别为 development, ad-hoc, app-store, enterprise 。必填
METHOD="development"
# 是否编译工作空间(例:若是用Cocopods管理的.xcworkspace项目,赋值true;用Xcode默认创建的.xcodeproj,赋值false)
IS_WORKSPACE="true"


# 上传方式：0不上传；1：蒲公英；2：fir；
UPLOAD_TYPE=1
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
	echo "***-----------------------------***"
	echo " build successful! Configurations!"
	echo "***-----------------------------***"
	git status
else
	echo "***-----------------------------***"
	echo "     error:create IPA failed!"
	echo "***-----------------------------***"
fi

# 判断上传方式
if [ ${UPLOAD_TYPE} == 1 ]; then
	#蒲公英
	echo "begin upload to pgyer..."
	echo -e "\n"
    curl -F "file=@${IPAPATH}/${IPANAME}/${SCHEMENAME}.ipa" -F "uKey=${MY_PGY_UK}" -F "_api_key=${MY_PGY_API_K}" https://qiniu-storage.pgyer.com/apiv1/app/upload
    echo -e "\n"
    echo "upload successful!"
elif [[ ${UPLOAD_TYPE} == 2 ]]; then
   	#fir
   	echo "begin upload to fir..."
   	echo -e "\n"
else
	echo "upload by hand!"
	echo -e "\n"
fi

# delete ARCHIVEPATH file
if [ -e $ARCHIVEPATH ]; then
	rm -rf $ARCHIVEPATH
	if [ $? -ne 0 ]; then
		echo "error: delete archivePath failed!"
		exit 1
	fi
fi

# delete EXPORT_OPTIONS_PLIST_PATH file
if [ -e $EXPORT_OPTIONS_PLIST_PATH ]; then
	rm -rf $EXPORT_OPTIONS_PLIST_PATH
	if [ $? -ne 0 ]; then
		echo "error: delete exprot options plist path failed!"
		exit 1
	fi
fi

# delete derivedData
if [ -e $CACHEPATH ]; then
	#mv $CACHEPATH ~/.Trash
	rm -rf $CACHEPATH
	if [ $? -ne 0 ]; then
		echo "error: delete trash files failed!"
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
echo "this shell script execution duration(脚本执行时长): ${SECONDS}s "


