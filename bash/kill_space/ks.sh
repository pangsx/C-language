#!/bin/bash
#1100911這是為了要把資料夾中空格刪除寫的腳本，因為我的轉換目錄腳本是用空格來定位的，所以對有空格的資料夾就會出錯，所以要用這個腳本把空格去除掉，目前因為長度有問題，所以算是半成品，特別注記一下。
(ls -l | grep "^d" | cut -d ':' -f 1|cut -d ' ' -f 7|cut -c 1-4) > rr.tt
n=$(ls -l| grep "^d" |wc -l)
i=1
file=rr.tt
while read line
do
	arr[$i]=$line
	((i++))
done < $file
i=1
until [ $n = 0 ]
do
	if [ ${arr[$i]} = 10月 ] || [ ${arr[$i]} = 11月 ] || [ ${arr[$i]} = 12月 ]
	then
 		c1=47
	else
		c1=46
	fi
	echo $n
	(ls -l | grep "^d" | cut -c $c1-|head -n $i |tail -n 1) >> rx.tt
	((i++))
	((n--))
done
file=rx.tt
i=1
while read line
do
	drr[$i]=$line
	echo ${drr[$i]}
	((i++))
done < $file
sed -i "s/[[:space:]]//g" rx.tt
file=rx.tt
i=1
while read line
do
	echo $line
	mv "${drr[$i]}" "$line" > /dev/null 2>&1
	((i++))
done < $file
rm *.tt > /dev/null 2>&1
