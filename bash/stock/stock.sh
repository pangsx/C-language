#!/bin/bash
#1100628想要寫一個能下載網頁資料來計算股票高、低、合理價的腳本，網路上有很多大德的成果，但是多是把全部資料下載回來，再做更進一步的技術分析，但這對我這種只想賺股利、股息的人來說，那些功能都太多了，所以寫個腳本來試著提昇功力吧。
#1100712https://www.stockinfo.tw/這個網站是不錯，但是有些股票找不到，像是威鋼這種公司應該算是不錯，但是找不到也是沒辦法，所以要再找其它網站後，再更新我的程式。
#1100712改成台銀證卷的版本，因為資料的來源變成二個不同的網頁，所以加入判斷要不要更新股利（息）的邏輯判斷，並且在判斷後，如果不更新，就把舊的資料取出來使用，自己覺得寫的差不多了，但還未實測。
#1100713改成台銀的版本執行的不錯，讀取股票名稱的地方有些小問題，但不影響使用，基本上也不必再用其它軟體再編輯了，反正這個算完顏色和是否合理都有了，小地方會再調整一下。
#function
summe(){
	file=$1.txt
	s=0
	i=1
	while read line2
	do
		if [ $i = 7 ] || [ $i = 15 ] || [ $i = 23 ] || [ $i = 31 ] || [ $i = 39 ] || \
		       [ $i = 47 ] || [ $i = 55 ] || [ $i = 63 ] || [ $i = 71 ] || [ $i = 79 ]  
		then
		s=$(echo $s+$line2|bc)
		else
		line2=$line2
		fi
		((i++))
	done < $file
	return 1		
}


#main
clear
#if [ -f "db.txt" ]
#then
	s=0
#else
#	echo "要有db.txt檔才能開始哦，我幫你弄一個吧^^"
#	touch db.txt
#fi

echo "如果不更新股利（息）資訊，請選1，要更新請選2，要查詢個股請選擇3"
read -p "輸入你的選擇:" sel
if [ $sel = 3 ]
then
	read -p "輸入你想選擇的個股編號，輸入名稱我看不懂哦" num
	rm db.txt
	echo $num > db.txt
elif [ $sel = 1 ] || [ $sel = 2 ]
then
	rm db.txt
	cp db.back db.txt
else
	echo "我不知道你想做什麼"
	touch db.txt
fi

file=db.txt
while read line
do
	wget --user-agent="Mozilla/5.0 （Windows; U; Windows NT 6.1; en-US） AppleWebKit/534.16 （KHTML， like Gecko）\
	       	Chrome/10.0.648.204 Safari/534.16" -nv --tries=5 --timeout=5 -O $line.html \
		https://fund.bot.com.tw/Z/ZC/ZCA/ZCA_$line.DJHTM
	#sleep 30
	iconv -f big5 -t utf8 $line.html > data1
	price=$(cat data1| grep "td class="|head -n 9|tail -n 1|cut -d '>' -f 2|cut -d '<' -f 1)
	name=$(cat data1| grep $line|tail -n 1|cut -d '(' -f 1)
	case $sel in
		2)
			wget --user-agent="Mozilla/5.0 （Windows; U; Windows NT 6.1; en-US） AppleWebKit/534.16 （KHTML， like Gecko）\
		       	Chrome/10.0.648.204 Safari/534.16" -nv --tries=5 --timeout=5 -O $line-d.html \
			https://fund.bot.com.tw/Z/ZC/ZCC/ZCC_$line.DJHTM
			sleep 30
			iconv -f big5 -t utf8 $line-d.html > data2
			(cat data2 |grep t3n1 |cut -d '>' -f 2|cut -d '<' -f 1) > $line-di.txt
			summe $line-di
			;;
		1)
			if [ -d "./dividend/" ] && [ -f "./dividend/$line-di.txt" ]
			then
				mv ./dividend/$line-di.txt .
			else
				echo "you don't have $line Data"
			fi
			;;
		3)
			wget --user-agent="Mozilla/5.0 （Windows; U; Windows NT 6.1; en-US） AppleWebKit/534.16 （KHTML， like Gecko）\
		       	Chrome/10.0.648.204 Safari/534.16" -nv --tries=5 --timeout=5 -O $line-d.html \
			https://fund.bot.com.tw/Z/ZC/ZCC/ZCC_$line.DJHTM
			sleep 30
			iconv -f big5 -t utf8 $line-d.html > data2
			(cat data2 |grep t3n1 |cut -d '>' -f 2|cut -d '<' -f 1) > $line-di.txt
			summe $line-di
			;;
		*)
			echo "i don't know ?"
			;;
	esac
	summe $line-di
	s1=$(echo 'scale=2;'$s/10|bc -l)
	sl=$(echo 'scale=2;'$s1*16|bc -l)
	sok=$(echo 'scale=2;'$s1*17.85|bc -l)
	sh=$(echo 'scale=2;'$s1*20|bc -l)
	echo $sl,$sok,$sh
	if [ $(echo "$price >= $sh"|bc -l) -eq 1 ] 
	then
		st="價太高了"
		echo -e $line,$name,$price,"\033[41;37m$st\033[0m"
		echo -e $line,$name,$price,"\033[41;37m$st\033[0m" >> sol1.txt
	elif [ $(echo "$price < $sh"|bc -l) -eq 1 ] && [ $(echo "$price > $sok"|bc -l) -eq 1 ]
	then
		st="高於合理價"
		echo -e $line,$name,$price,"\033[43;37m$st\033[0m"
		echo -e $line,$name,$price,"\033[43;37m$st\033[0m" >> sol1.txt
	elif [ $(echo "$price < $sok"|bc -l) -eq 1 ] && [ $(echo "$price > $sl"|bc -l) -eq 1 ]
	then
		st="在合理價以內"
		echo -e $line,$name,$price,"\033[44;37m$st\033[0m"
		echo -e $line,$name,$price,"\033[44;37m$st\033[0m" >> sol1.txt
	elif [ $(echo "$price <= $sl"|bc -l) -eq 1 ]
	then
		st="低於低價"
		echo -e $line,$name,$price,"\033[42;37m$st\033[0m"
		echo -e $line,$name,$price,"\033[42;37m$st\033[0m" >> sol1.txt
	else
		echo -e $line,$name,$price,"\033[41;37msome thing wrong\033[0m"
		echo -e $line,$name,$price,"\033[41;37msome thing wrong\033[0m" >> sol1.txt
	fi
	ss=$(echo 'scale=2;'$s1*100/$price|bc -l)
	echo $line,$name,$price,$st,$sl,$sok,$sh,$ss% >> sol.txt
done < $file

mv sol1.txt $(date '+%Y%m%d')sol1.log
mv sol.txt $(date '+%Y%m%d')sol.log
if [ -d "dividend" ]
then
	s=$s
else
	mkdir dividend
fi
mv -u ./*.txt ./dividend

if [ -d "stock" ]
then
	s=$s
else
	mkdir stock
fi
mv -f ./*.html ./stock
rm data?
rm *.txt
