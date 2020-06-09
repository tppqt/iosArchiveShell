#!/bin/bash
# author wangyingbo


# 拼接前缀
# ssh root@172.16.15.94   -i ~/.ssh/id_rsa.github
# ssh root@172.16.15.94   -i ~/.ssh/id_rsa.github  ls /home/fengbang/app/bapp-apk-sql/apache-tomcat-7.0.52/webapps/ROOT/fengbangb_web


# 配置无密码访问ssh  用scp上传或者ssh-copy-id上传公钥
# cat id_rsa.pub >> authorized_keys
# scp .ssh/authorized_keys root@172.16.15.94


USER_IP='root@172.16.15.94'
SSH_CONTACT='ssh root@172.16.15.94'
APP_NAME='fengbangb_web'
PRE_SRC='/home/fengbang/app/bapp-apk-sql/apache-tomcat-7.0.52/webapps/ROOT'
APP_SRC=${PRE_SRC}/${APP_NAME}


if [ -d "dist" ] ; then
	cp -a dist ${APP_NAME}
	zip -q -r ${APP_NAME}.zip ${APP_NAME}
	rm -rf ${APP_NAME}
	echo -e "\033[32;40m ***-------------拷贝dist目录，生成项目文件夹，并压缩----------------*** \033[0m"
else
	echo -e "\033[31;40m ***-------------当前不存在dist文件夹----------------*** \033[0m"
	exit 0
fi


deleteCacheFiles(){
	para=0

	rm -rf ${APP_NAME}
	rm -rf ${APP_NAME}.zip
	if [ ! -d ${APP_NAME} ] ; then 
		echo -e "\033[32;40m ***-------------删除缓存文件夹成功----------------*** \033[0m"
		para=1
	else
		rm -rf ${APP_NAME}
		rm -rf ${APP_NAME}.zip
		cat <<EOF
		自动删除生成的缓存文件夹:
			删除fengbangb_web文件夹
			或
			删除fengbangb_web.zip文件
EOF
	fi
	return $para
}


files=$(${SSH_CONTACT} ls ${APP_SRC} 2> /dev/null | wc -l) 
if [ $files -ne 0 ] ; then 
	${SSH_CONTACT} ls ${PRE_SRC}
	echo -e "\033[32;40m ***-------------删除旧项目成功----------------*** \033[0m"
	# 创建测试用的文件夹wybtest以及wybtest.zip文件，并删除
	# ${SSH_CONTACT} touch ${PRE_SRC}/wybtest.zip
	# ${SSH_CONTACT} touch ${PRE_SRC}/wybtest
	# ${SSH_CONTACT} rm -rf ${PRE_SRC}/wybtest
	# ${SSH_CONTACT} rm -rf ${PRE_SRC}/wybtest.zip

	# 删除服务器上已经有的文件 TODO
	${SSH_CONTACT} rm -rf ${PRE_SRC}/${APP_NAME}
	${SSH_CONTACT} rm -rf ${PRE_SRC}/${APP_NAME}.zip
	${SSH_CONTACT} ls ${PRE_SRC}
else
	${SSH_CONTACT} rm -rf ${PRE_SRC}/${APP_NAME}
	${SSH_CONTACT} rm -rf ${PRE_SRC}/${APP_NAME}.zip
	echo -e "\033[32;40m ***-------------不存在旧项目----------------*** \033[0m"
fi

#上传远程文件
sftp_upload_file(){
	sftp ${USER_IP}<<EOF
	  put -r $1 $2
	  quit
EOF
}

# 上传本地的zip文件到服务器
echo -e "\033[33;40m ***-------------开始上传----------------*** \033[0m"
sftp_upload_file ${APP_NAME}.zip ${PRE_SRC}
fileszip=$(${SSH_CONTACT} ls ${APP_SRC}.zip 2> /dev/null | wc -l)
if [ $fileszip -ne 0 ] ; then 
	echo -e "\033[33;40m ***-------------存在zip文件，则解压----------------*** \033[0m"
	${SSH_CONTACT} unzip -n ${APP_SRC}.zip -d ${PRE_SRC}
fi

${SSH_CONTACT} ls ${PRE_SRC}


deleteCacheFiles



