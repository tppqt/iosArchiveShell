
#!/bin/bash
# https://blog.csdn.net/Ruffaim/article/details/84936175

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
echo $IFS
# --quality=0-5 即压缩质量范围在0-5，最大可配置10，区间越小提及越小。
# find . -name '*.png' | xargs ./pngquant --quality=0-5

for f in *.png;
    do
        ./pngquant --quality=1-5 $f
    done

re='-fs8.png'
for f in *-fs8.png;
    do
        fn=${f/$re/.png}
        echo "$fn"
	#存在当前目录的new文件夹 所以需要新建好new
        mv $f ./new/$fn;
    done

IFS=$SAVEIFS