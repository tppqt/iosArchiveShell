#!/bin/bash
# author wangyingbo


# 拼接前缀
# ssh root@172.16.15.94   -i ~/.ssh/id_rsa.github



# ssh root@172.16.15.94   -i ~/.ssh/id_rsa.github  ls /home/fengbang/app/bapp-apk-sql/apache-tomcat-7.0.52/webapps/ROOT/fengbangb_web


files=$(ssh root@172.16.15.94  -i ~/.ssh/id_rsa.github ls /home/fengbang/app/bapp-apk-sql/apache-tomcat-7.0.52/webapps/ROOT/fengbangb_web 2> /dev/null | wc -l) 
if [ $files -ne 0 ] ; then 
	echo -e "\033[32;40m ***-------------删除旧项目----------------*** \033[0m"
	# rm -rf fengbangb_web
fi

# rm -rf fengbangb_web

