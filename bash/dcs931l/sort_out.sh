#!/bin/bash
#1100609
#因為我的網路攝影機d-link dcs931l會用FTP方式來上傳資料，包含影片和照片這兩種資料，其中影片是會自己產生資料夾來存放，而照片則是不會，
#所以我想要寫一個簡單的腳本來做自動分類，也是學著好好使用ubuntu的一個過程，就開始吧。
#1100617
#今天預計加入讀出建檔時間的機制，並且由建檔時間來建立資料夾，再把jpg檔依序放入。
#基本上jpg檔的自動整理算是完成了，要實測一下才能知道了。
#1100617
#完成了，來說明一下怎麼用，執行這個腳本，會建立一個叫sort_out的資料夾，其中分別建立jpg及avi二個資料夾，avi資料夾是放影片的，因為原本
#就有依時間了，所以叭是簡單的把資料夾依年份來分類，jpg資料夾則是會依檔案建立的時間，依年份和建立的月、日來分類資料夾，這是我自己寫出
#來的第一個腳本，希望能好好工作，有機會再來完善它。

#cd /
#cd /media/pang/6233-6163/scripts/dcs931l/
ls -d */ > d.txt
ls *.jpg > f.txt

#製作log來紀錄
cat d.txt > $(date '+%Y%m%d').log
cat f.txt >> $(date '+%Y%m%d').log
#

#以下抄了網路上的高手的程式來試試,但後來也沒用，只是參考
#file=d.txt
#seq=1
#while read line
#do
#	lines[$seq]=$line
#	((seq++))
#done < $file
#for ((i=1;i<=${#lines[@]};i++))
#do
#	echo ${lines[$i]}
#done
#這以上也是抄高手的程式，但下半部我認為是重複的，所以我先把它注釋掉了。

#前置工作，先建資料夾^^
mkdir sort_out
cd sort_out
mkdir jpg
mkdir avi
cd ..
sj='sort_out/jpg'
sn='sort_out/avi'
#




#以下是我自己針對jpg檔來處理的部分寫的程式
n=$(ls *.jpg|wc -l)
until [ $n == 0 ]
do
	a=$(ls *.jpg|head -n 1)
	#用來取得第一個檔案的名稱
	b=$(stat $a|grep 最近存取：)
	b1=${b:5:4}
	b2=${b:10:2}${b:13:2}
	b3=${b:16:2}${b:19:2}
	#這一段是為了要把檔案的年月日分出來，以為後續建資料夾用
	mkdir ./$sj/$b1 >> $(date '+%Y%m%d').log
	#製作指定的目錄
	mkdir ./$sj/$b1/$b2 >> $(date '+%Y%m%d').log
	mkdir ./$sj/$b1/$b2/$b3 >> $(date '+%Y%m%d').log
	a=${a:0:22}
       	#取共同的部分才能當分類的依據哦
	(ls *.jpg|grep $a) >b.txt
       	#把有共同字串的檔案名輸出到b.txt這個資料夾
	file=b.txt
	seq=1
	while read line
	do
		mv $line ./$sj/$b1/$b2/$b3 >> $(date '+%Y%m%d').log
	       	#移動檔案到指定的目錄
		((seq++))
		((n--))
	done < $file
done
#jpg檔的整理到此結束

#以下是資料夾整理的部分
nn=$(ls -d */|wc -l)
echo $nn
nn=`expr $nn - 1`
echo $nn
until [ $nn == 0 ]
do
	na=$(ls -d */|head -n 1)
	na=${na:0:4}
	(ls -d */|grep $na) >na.txt
	mkdir ./$sn/$na >> $(date '+%Y%m%d').log
	#製作指定的目錄
	file=na.txt
        seq=1
        while read line
        do
                mv $line ./$sn/$na >> $(date '+%Y%m%d').log
                #移動檔案到指定的目錄
                ((seq++))
                ((nn--))
        done < $file
done
#資料夾整理到此結束

#清除暫存檔案
rm *.txt
