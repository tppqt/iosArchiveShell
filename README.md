# 自动打包脚本说明


**在`.xcodeproj`或`.workplace`文件的同名目录下，运行**

		chmod +x archive.sh
		./archive.sh

**运行效果**

![screen_shot](https://raw.githubusercontent.com/wangyingbo/PrivateImages/master/2019/sh_screen_shot.1cawza1yinu.png)

**如果脚本里的配置项`MODE`、`METHOD`、`IS_WORKSPACE`、`UPLOAD_TYPE`字段都设置了默认值，则直接运行；如果个别字段没有默认值，则会分别提示输入相应的值，然后根据输入的值选择打包模式运行；**

*脚本里的默认全局变量解释以及设置：*

> + SCHEMENAME：scheme name, 可以用xcodebuild -list命令查看scheme name，这个参数名必须设置；
> + MODE：打包的环境，可以设置默认值Debug 或者 Release；如果不设置留空的话，则运行脚本的时候会提示选择输入；
> + METHOD：打包渠道，可以设置默认值为： development, ad-hoc, app-store, enterprise；如果不设置留空的话，则运行脚本的时候会提示选择输入；
> + IS_WORKSPACE：是否包含工作区间workplace（一般使用cocoapod管理项目时会用workplace），可以设置默认值为：false或true；如果不设置留空的话，则运行脚本的时候会提示选择输入；
> + UPLOAD_TYPE：上传方式的值，可以设置默认值为：0：不上传；1：蒲公英；2：fir；如果不设置留空的话，则运行脚本的时候会提示选择输入；
> + MY_PGY_API_K：如果选择上传渠道为蒲公英，必传；[蒲公英接口文档获取_api_key和uKey](https://www.pgyer.com/doc/api#uploadApp)；
> + MY_PGY_UK：如果选择上传渠道为蒲公英，必传；
> + FIR_TOKEN：如果选择上传渠道为fir，必传；[firtoken](https://fir.im/docs)；[fir地址](https://fir.im/apps);

*一些默认的路径参数配置：*
> + DATE：生成的文件夹的名称拼接的时间格式；
> + CACHEPATH：缓存文件夹的路径，默认缓存文件夹生成在桌面，打包上传成功后会自动删除缓存文件夹；
> + ARCHIVEPATH：生成缓存archive文件的路径，默认在`CACHEPATH`文件夹里；
> + EXPORT_OPTIONS_PLIST_PATH：生成`ExportOptions.plist`文件的路径，默认在`CACHEPATH`里；
> + IPAPATH：生成的.ipa文件路径，默认在桌面；
> + IPANAME：生成的ipa的name，默认是schemename拼接时间；


**如果运行成功，则会在桌面生成一个缓存文件夹，打包成功则会在桌面生成`.ipa`包文件，然后自动删除缓存文件夹。**


