#!/bin/bash
bigreward(){
#echo "this is bigreward"
	if [ $# != 7 ]
	then
		echo "要輸入數期和號碼才能對獎哦，檢查一下吧"
		exit 2
	fi
	an=$(cat bigf.txt | grep "$1" | head -n 1)
 	echo $an > temp.dc
	if [ -z $an ]
	then
		bonus="notyet"
	else
		worksp $1 $2 $3 $4 $5 $6 $7
	fi
	echo $bonus > temp.db
}

worksp(){
		(cat temp.dc | cut -d '^' -f 2) >t1.dc
		sp=$(cat temp.dc |cut -d '^' -f 2|cut -d ',' -f 7)
		if [ $2 = $sp ] || [ $3 = $sp ] || [ $4 = $sp ] || [ $5 = $sp ] || [ $6 = $sp ] || [ $7 = $sp ]
		then
			countre $1 $2 $3 $4 $5 $6 $7
			case $countsol in
				1)
					echo "sorry~~~"
					bonus=0
					;;
				2)
					echo "400元，爽啦"
					bonus=400
					;;
				3)
					echo "中1000元啦～～"
					bonus=1000
					;;
				4)
					echo "中萬元以上，不錯哦"
					bonus="10000up"
					;;
				5)
					echo "中百萬元以上，爽～～～"
					bonus="1,000,000up"
					;;
				6)
					echo "沒這個可能，有問題哦～～"
					bonus="imp"
					;;
				0)
					echo "sorry"
					bonus=0
					;;
			esac
		else
			countre $1 $2 $3 $4 $5 $6 $7
			case $countsol in
				3)
					echo "中400元～～～"
					bonus=400
					;;
				4)
					echo "中2000元，真不錯"
					bonus=2000
					;;
				5)
					echo "中5萬元以上，哦耶～～～"
					bonus="50,000up"
					;;
				6)
					echo "中頭彩啦～～～～"
					bonus="bigone"
					;;
				*)
					echo "sorry"
					bonus=0
					;;
			esac
		fi
}





countre(){
	temp=$(echo $2,$3,$4,$5,$6,$7)
	countsol=0
	i=1
	for i in {1..6}
	do
		checkco=$(cat t1.dc|grep "$(echo $temp| cut -d ',' -f $i)")
		if [ -n "$checkco" ]
		then
			((countsol++))
			((i++))
		else
			((i++))
		fi
	done
}

bigreward $1 $2 $3 $4 $5 $6 $7
rm *.dc
