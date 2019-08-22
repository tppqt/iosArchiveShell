#!/bin/bash
# author wangyingbo

set -e

create(){
	echo -e "something happend \n wow!!"
}

# create


BINARY_DIR=/usr/local/bin/
TEMPLATES_DIR=~/.appledoc

# https://blog.csdn.net/zongshi1992/article/details/71693045
# < :输入重定向
# > :输出重定向
# >> :输出重定向,进行追加,不会覆盖之前内容
# << :标准输入来自命令行的一对分隔号的中间内容.


usage() {
cat <<EOF
Usage: $0 [-b binary_path] [-t templates_path]
Builds and installs appledoc
OPTIONS:
    -b  Path where binary will be installed. Default is $BINARY_DIR
    -t  Path where templates will be installed. Default is $TEMPLATES_DIR
    
EOF
}

# https://blog.csdn.net/xluren/article/details/17489667
while getopts "hb:t:" OPTION
do
	case $OPTION in
		h) usage
		   exit 0;;
		b)
		   BINARY_DIR=$OPTARG;;
		t)
		   INSTALL_TEMPLATES="YES"
           echo "arg is = $OPTARG"
		   if [ "$OPTARG" != "default" ]; then
		      TEMPLATES_DIR=$OPTARG
		   fi
		   ;;
		[?])
			usage
			exit 1;;
	esac
done


# echo "Building..."
# xcodebuild -workspace appledoc.xcworkspace -scheme appledoc -derivedDataPath /tmp -configuration Release install

install -v /tmp/Build/Intermediates.noindex/ArchiveIntermediates/appledoc/InstallationBuildProductsLocation/usr/local/bin/appledoc "$BINARY_DIR"

if [ "$INSTALL_TEMPLATES" == "YES" ]; then
    echo "Copying templates to $TEMPLATES_DIR"
    cp -R Templates/ "$TEMPLATES_DIR"
fi