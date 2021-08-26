#!/bin/bash
#1100803為了要建立我自己的網站管理工具，所以思考了如何算有多少目錄，並且移動到目錄內的方法，雖然是有套件tree可以用，但是為了磨練自己的功力，並且為了未來能更有彈性的使用，所以我還是自己寫了，這個腳本可以完成我的需求，紀錄一下。
#1100806計劃加入計算檔案數及清單的功能，為自動建立網站的基礎工作，再進一步。
rm *.txt > /dev/null 2>&1
i=$(ls -lR | grep "^d" | wc -l)
basedir=$(pwd)
echo $basedir > dir.txt
j=0
until [ $i = 0 ]
do
	case $j in
		0)
			(ls -l|grep "^d"|cut -d ':' -f 2|cut -d ' ' -f 2) > temp.txt
			f=$(ls -l | grep "^-" | wc -l)
			file=temp.txt
			while read line
			do
				cd $line
				pwd >> "$basedir/dir.txt"
				pwd >> "$basedir/back.log"
				(ls -l|grep "^-")  >> "$basedir/back.log"
				f=$(echo $f+$(ls -l | grep "^-" | wc -l)|bc)
				((i--))
				cd $basedir
			done < $file
			((j++))
			rm temp.txt
			;;
		*)
			((j++))
			workdir=$(sed -n "$j"p "$basedir/dir.txt")
			cd $workdir
			n=$(ls -l|grep "^d"|wc -l)
			if [ $n = 0 ]
			then
				(ls -l|grep "^-")  >> "$basedir/back.log"
				f=$(echo $f+$(ls -l | grep "^-" | wc -l)|bc)
			else
				(ls -l|grep "^d"|cut -d ':' -f 2|cut -d ' ' -f 2) > temp.txt
				file=temp.txt
				while read line
				do
					cd $line					
					pwd >> "$basedir/dir.txt"
					pwd >> "$basedir/back.log"
					(ls -l|grep "^-")  >> "$basedir/back.log"
					f=$(echo $f+$(ls -l | grep "^-" | wc -l)|bc)
					((i--))
					cd $workdir
				done < $file
				rm temp.txt
			fi
			;;
	esac
done
cd $basedir
echo `pwd`
echo "dir:$(ls -lR | grep "^d" | wc -l) ,file:$f"

