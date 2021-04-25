#!/bin/bash


start_time_ms=$(date "+%Y%m%d%H%M%S")$((`date +%N`/1000000))


startTime=`date +%Y%m%d-%H:%M:%S`
startTime_s=`date +%s`

endTime=`date +%Y%m%d-%H:%M:%S`
endTime_s=`date +%s`

sumTime=$[ $endTime_s - $startTime_s ]

echo "$startTime ---> $endTime" "Total:$sumTime seconds"

# time=$(date "+%Y-%m-%d %H:%M:%S")
for (( i = 0; i < 1000000; i++ )); do
	echo $i
done

end_time_ms=$(date "+%Y%m%d%H%M%S")$((`date +%N`/1000000))
sum_ms=$[ $end_time_ms - $start_time_ms ]
echo ""
echo "开始毫秒：$start_time_ms 结束毫秒：$end_time_ms 差值：$sum_ms 毫秒"