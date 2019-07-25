#!/bin/bash
# author wangyingbo

# scheme name, 可以用xcodebuild -list
SCHEMENAME="FengbangB"
# Debug 或者 Release
MODE='Debug'

# 定义
WORKSPACE=${SCHEMENAME}.xcworkspace
DATE=`date +%Y%m%d_%H%M`
CACHEPATH=~/Desktop/derivedData
ARCHIVEPATH=~/Desktop/${SCHEMENAME}
IPAPATH=~/Desktop
IPANAME=${SCHEMENAME}_$DATE.ipa


# *****************************用xcodebuild archive打包*****************************

# # xcodebuild archive 打包
# # 如果有workspace则需要加参数 -workspace $WORKSPACE
# xcodebuild archive -scheme ${SCHEMENAME} -configuration $MODE clean build -archivePath $ARCHIVEPATH
# # xcodebuild -exportArchive必须需要 -exportOptionsPlist参数，把路径写上去
# xcodebuild -exportArchive -archivePath $ARCHIVEPATH -exportOptionsPlist -exportPath $IPAPATH/$IPANAME

# if [ -e $IPAPATH/$IPANAME ]; then
# 	echo "***---------------------***"
# 	echo "build successful! Configurations!"
# 	echo "***---------------------***"
# 	git status
# else
# 	echo "***---------------------***"
# 	echo "error:create IPA failed!"
# 	echo "***---------------------***"
# fi

# # delete ARCHIVEPATH file
# if [ -e $ARCHIVEPATH ]; then
# 	rm -rf $ARCHIVEPATH
# 	if [ $? -ne 0 ]; then
# 		echo "error: delete trash files failed!"
# 		exit 1
# 	fi
# fi


# *****************************用xcodebuild和xcrun打包*****************************

# xcodebuild 
# 如果有workspace则需要加参数 -workspace $WORKSPACE
xcodebuild \
 -workspace $WORKSPACE \
 -scheme ${SCHEMENAME} \
 -configuration $MODE \
 clean \
 build \
 -derivedDataPath $CACHEPATH

# xcrun打包 - 用PackageApplication工具打包。
# 打包找不到 "PackageApplication" 文件, https://blog.csdn.net/qq_19484963/article/details/79094554
# warning: PackageApplication is deprecated, use `xcodebuild -exportArchive` instead
xcrun \
 -sdk iphoneos PackageApplication \
 -v $CACHEPATH/Build/Products/Debug-iphoneos/${SCHEMENAME}.app \
 -o $IPAPATH/$IPANAME

if [ -e $IPAPATH/$IPANAME ]; then
	echo "***---------------------***"
	echo "build successful! Configurations!"
	echo "***---------------------***"
	git status
	#git log -2
	#open $IPAPATH
else
	echo "***---------------------***"
	echo "error:create IPA failed!"
	echo "***---------------------***"
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


