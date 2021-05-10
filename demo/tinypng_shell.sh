#!/bin/bash
# https://blog.csdn.net/zhenyu5211314/article/details/50437722


dir=/Users/shake/Documents/tinypng/retry1
dir2=/Users/shake/Documents/tinypng/target2
echo Enter $dir
cd $dir
mkdir -p $dir2
travel_file()
{
    echo $1    
    mkdir -p $2
    for file in `ls $1`
    do
        if [ -f "$1/$file" ]; then
            echo $1/$file
            if [ ${file##*.} == "png" ] || [ ${file##*.} == "PNG" ]; then
                for i in {1..100}
                do
                    echo upload$i $1/$file
                    url=$(cat $1/$file | curl -i --user api:NCNsuEsbrM3tFqR4XP1Urm_Yw-E1e-em --data-binary @- https://api.tinypng.com/shrink --connect-timeout 10 -m 2000 | grep "Location" | cut -c 11-)
                    if [ -n "$url" ]; then
                        break
                    fi
                done
 
                for i in {1..100}
                do
                    echo getlength$i $url
                    length=$(curl --head $url --connect-timeout 10 -m 30 | grep "Content-Length" | cut -c 17-)
                    if [ -n "$length" ]; then
                        length=${length:0:${#length}-1}
                        echo length ${#length} $length
                        break
                    fi
                done
 
                for i in {1..100}
                do
                    echo download$i $url                    
                    curl $url > $2/$file --connect-timeout 10 -m 400
                    len=$(ls -l $2/$file | awk '{print $5}')
                    echo len ${#len} $len
                    echo length ${#length} $length
                    if [ $len == $length ]; then
                        echo success! $file
                        break
                    fi
                done
            fi
        fi
        if [ -d "$1/$file" ]; then
            travel_file $1/$file $2/$file
        fi
    done
 
}
 
 
travel_file $dir $dir2
