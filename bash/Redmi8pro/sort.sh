#!/bin/bash
#1100624 ver.1.0
#之前幫ip com寫的腳本算是成功的，所以我想說也幫我的手機紅米 note 8 pro的照片也寫一個腳本來整理，之前整理照片可能都要我一個半
#天的時間，希望用上了腳本能縮段這個時間。因為和之前的腳本沒有多什麼新的東西，所以一個上午就完成了，真好。
#1100624 ver.2.0
#原本己經完成的，但是我後來發現，FB和LINE的照片和影片沒有依日期來命名，所以為了一併整理，不必再另外寫一個腳本，我決定要升級原
#本的版本，一方面我要加入function的方式來寫，才不會重複的地方太多，二方面，加入選擇功能，就可以決定要做什麼，雖然這個功能很白
#痴，但是是增進我寫腳本的功力，結果select case算是很成功的運作了，也用了一個無窮迴圈來處理，不必選了一個就要再執行一次腳本，
#但是function的部分有問題，原本的版本沒有這個問題，讓我有點困擾，為什麼function的變數不是我預期，明天再想辦法解決。
#1100625 ver.3.0
#測試不用function的方式能不能執行。
#經過改寫，不使用function是可行的，我也在git內紀錄了，所以再回來寫有function功
#的版本。
#1100624 ver.3.1
#function功能完成，確定可以使用了，可以部分的減輕我的整理工作囉。
#1101005 ver.3.2
#資料夾加上民國，和之前的一致，我整理才不必再自己動手。
#
#



#set -e 加入這行指令可以讓腳本有錯誤時就停止，但目錄如果存再，沒辦法再建立時，就會直接跳出，這太難搞了，我不想每個都弄判斷。

ls -al > f.txt

#製作log來紀錄
d=$(date '+%Y%m%d')
cat f.txt > $d.log
#依日期來建整理的資料夾
dd=sort_out$d
mkdir $dd

#function
sortout(){
m1=$(ls *.$1|head -n 1)
#用來取得第一個檔案的名稱
if [ -e $m1 ];then
	nm=$(ls *.$1| wc -l)
	until [ $nm == 0 ]
	do
		m=$(ls *.$1|head -n 1)
		#用來取得第一個檔案的名稱
		t=$(stat $m|grep 最近變更：)
		t1=${t:5:4}
        	t2=${t:10:2}${t:13:2}
        	#這一段是為了要把檔案的年月日分出來，以為後續建資料夾用
		t1=$(echo "$t1-1911"|bc -l)
		#把西元變成民國
        	mkdir ./$dd/$t1 >> $d.log
        	mkdir ./$dd/$t1/$t1$t2 >> $d.log
        	#製作指定的目錄
        	b1=${m:4:4}
		b2=${m:8:4}
		(ls *.$1|grep $b1$b2) >b.txt
        	#把有共同字串的檔案名輸出到b.txt這個資料夾
        	file=b.txt
        	seq=1
        	while read line
        	do
                	mv $line ./$dd/$t1/$t1$t2 >> $d.log
                	#移動檔案到指定的目錄
                	((seq++))
                	((nm--))
        	done < $file
	done
	rm *.txt
else
	echo "no $1 file"
fi
return 1
#
}

#
name=a 
echo $name
until [ $name == 0 ]
do
	clear
	echo "選擇你想整理檔案的副檔名"
	echo "輸入1是整理jpg檔"
	echo "輸入2是整理mp4檔"
	echo "輸入3是整理avi檔"
	read -p "輸入你的選擇:" name
	case $name in
		1)sortout jpg
			;;
		2)sortout mp4
			;;
		3)sortout avi
			;;
		0) echo "bye bye"
			;;
		*) echo "真抱歉，我不知道你想搞什麼"
	esac
	
done

rm *.txt
