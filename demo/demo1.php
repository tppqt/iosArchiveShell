#!/bin/bash
#!/usr/bin/php

# https://github.com/qinjx/30min_guides/blob/master/shell.md

# 变量名和等号之间不能有空格
your_name="hello world"
echo ${your_name}

your_name="wyb"
# 变量名外面的花括号是可选的，加不加都行，加花括号是为了帮助解释器识别变量的边界
echo ${your_name}

# 双引号里可以有变量
# 双引号里可以出现转义字
str="hello, i know you are \"${your_name}\",yes"
echo ${str}

test1="yes,"
test2="you are right"
echo $test1 $test2

# 单引号字符串的限制
# 单引号里的任何字符都会原样输出，单引号字符串中的变量是无效的
# 单引号字串中不能出现单引号（对单引号使用转义符后也不行）
str1='this is a string'

# 拼接字符串
myName="wangyingbo"
student=" ${myName} is a student"
echo ${student}

# 获取字符串长度
string="abcdefghijklmn"
echo ${#string} #输出：

# 提取字符串
string="alibaba is a great company"
echo ${string:1:4} #输出：liba

# 查找子字符串
string="alibaba is a great company"
#输出：3，这个语句的意思是：找出字母i在这名话中的位置，要在linux下运行，mac下会报错
#echo `expr index "$string" is`


if 
then 
	echo hello
fi
