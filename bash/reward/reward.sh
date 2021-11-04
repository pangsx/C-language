#!/bin/bash
#自己寫一個對大樂透和威透彩的對獎腳本，雖然有app，但是太笨了，如果有加碼，還要輸入二次，不好用。
#1101103完成了初版的對獎程式了，把程式分成幾個部分來處理，避免全部寫在一個腳本內，要除錯會很痛苦，這是看書的好處，另外加碼的部分，我放棄放在這個腳本內解決，一來加碼的網頁不固定，要解析出數字來，也是必需要另外想辦法，二來是加碼對獎的方式又是另外的，所以，如果有加碼出來後，再來增加腳本的功能會是比較好的方式，以上先行紀錄一下。
#說明一下各個腳本的功能：
#1.makedb:這個腳本主要是幫忙下載資料做成資料檔用的，他的功能很簡單，只初步判斷有沒有先前的資料檔，如果有就會增加新的資料，不會把舊的刪掉。
#2.readdb:這個腳本會讀入我買的獎卷的輸入檔，分解後再呼叫對獎的腳本，主要工作都在這個腳本內執行。
#3.happyreward&bigreward:這是對獎的核心功能，因為不同獎項的遊戲方式不同，所以沒辦法寫在一起。
#最後，我承認別人的程式可能真的很蠢，但是寫一個程式來處理真的很困難，我這個對獎程式寫了要一週，除錯和功能真的要先想好才是。
clear
echo "input you want to reward?1 for happy,2 for big."
read sel
case $sel in
	1)
		curl -o happy.db https://www.taiwanlottery.com.tw/lotto/superlotto638/history.aspx
		if [  -e happyf.txt ]
		then
			ss=1;
		else
			ss=2;
		fi
		./makedb.sh happy.db SuperLotto638Control_history1_dlQuery_DrawTerm SuperLotto638Control_history1_dlQuery_Date SuperLotto638Control_history1_dlQuery_SNo $ss $sel
		cat tempp.txt >> happyf.txt
		rm tempp.txt 2>/dev/null
		if [  -e happy1.txt ]
		then
		./readdb.sh happy1.txt $sel
		else
		echo "no input file"
		fi
		;;
	2)
		curl -o big.db https://www.taiwanlottery.com.tw/lotto/Lotto649/history.aspx
		if [  -e bigf.txt ]
		then
			ss=1;
		else
			ss=2;
		fi
		./makedb.sh big.db Lotto649Control_history_dlQuery_L649_DrawTerm Lotto649Control_history_dlQuery_L649_DDate Lotto649Control_history_dlQuery_SNo $ss $sel
		cat tempp.txt >> bigf.txt
		rm tempp.txt
		if [  -e big1.txt ]
		then
		./readdb.sh big1.txt $sel
		else
		echo "no input file"
		fi
		;;
	*)
		echo "i do not know that,bye!"
		exit 0
		;;
esac


