#!/bin/bash
# author wangyingbo


files=$(ls *.php 2> /dev/null | wc -l)
echo -e "${files}"

phpFile=$(ls *.php)
echo -e "${phpFile}"
