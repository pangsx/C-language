#!/bin/bash
#1100806組合網頁的腳本，測試中。
#1100831基本上是己經完成，但是細節要進行測試，也要幫腳本建立註解，不然寫了太久會不知道自己在寫什麼。完成了一些修正和調整，為了腳本不要誤判，名稱內不要有空格。
#function
#以下是建立捷徑和index.html的函數。
makelink(){
	rm *.html > /dev/null 2>&1
	rm 0 > /dev/null 2>&1
	(ls -l|grep "^-")  >> "$basedir/back.log"
	f=$(echo $f+$(ls -l | grep "^-" | wc -l)|bc)
	cp $basedir/.html_temp/2head.t1 $1/index.html
	cd ..
	backdir=`pwd`
	#為了做back捷徑，所以需要知道上一層目錄
	cd $1
	echo '<div id ="date" style="display:inline;font-size:25px;">' >> $1/index.html
	echo "<a href="$backdir/index.html">上一層</a>" >> $1/index.html
	#做back捷徑
	#判斷要不要做下一層資料夾的捷徑。
	checkdir=$(ls -l|grep "^d"|wc -l)
	if [ $checkdir != 0 ]
		#不等於零表示有資料夾，所以要做捷徑。
	then
		rm $1/*.tt > /dev/null 2>&1
		(ls -l|grep "^d"|cut -d ':' -f 2|cut -d ' ' -f 2) > $1/ftemp.tt
		file2=$1/ftemp.tt
		while read line2
		do
			echo "<a href="`pwd`\\$line2\\index.html">$line2</a>" >> $1/index.html
		done < $file2
	fi
	echo '</date></div><hr></hr>' >> $1/index.html
	rm $1/*.tt > /dev/null 2>&1
	#判斷有沒有jpg,png,gif以外的檔案，有就幫它做連結。
	check=$(ls -cl|grep "^-"|grep -v .jpg|grep -v .png |grep -v .gif|grep -v .html|wc -l)
	if [ $check = 0 ]
	then
		check=0
	else	
		rm $1/*.tt > /dev/null 2>&1
		(ls -cl|grep "^-"|grep -v .jpg|grep -v .png |grep -v .gif|grep -v .html|grep -v .tt|cut -d ':' -f 2|cut -d ' ' -f 2) > $1/ftemp.tt
		file2=$1/ftemp.tt
		while read line2
		do
			echo "<p><a href="`pwd`\\$line2">$line2</a></p>" >> $1/index.html
		done < $file2
	fi
	rm $1/*.tt > /dev/null 2>&1
	#判斷有沒有圖檔，要做圖檔的捷徑，目前我僅對jpg,png,gif檔有反應。
	photon=$(echo $(ls *jpg|wc -l)+$(ls *png|wc -l)+$(ls *gif|wc -l)|bc)
	if [ $photon > 0 ]
	then
		rm $1/*.tt > /dev/null 2>&1
		(ls *jpg) > $1/ftemp.tt
		(ls *png) >> $1/ftemp.tt 
		(ls *gif) >> $1/ftemp.tt
		file2=$1/ftemp.tt
		while read line2
		do
			echo "<div class="img"><a target="_blank" href="`pwd`\\$line2"><img src="$line2" width="300" height="200"></a><div class="desc">$line2</div></div>" >> index.html
		done < $file2
	rm $1/*.tt > /dev/null 2>&1
	fi
	cat $basedir/.html_temp/2back.t >> $1/index.html	
return 1	
}


#main
rm *.tt > /dev/null 2>&1

basedir=$(pwd)
echo $basedir > dir.tt
rm index.html > /dev/null 2>&1
#這段是在建立index.html所需要的css和標題等檔頭文件。
cp $basedir/.html_temp/head.t $basedir/.html_temp/1head.t
cp $basedir/.html_temp/back.t $basedir/.html_temp/2back.t
#basedir是腳本所在的目錄，接下來會把此路徑寫入所需的暫存文件中
sed -i "s?up?$basedir/.html_temp/up?g" $basedir/.html_temp/1head.t
sed -i "s?photo?$basedir/.html_temp/photo?g" $basedir/.html_temp/1head.t
sed -i "s?logo?$basedir/.html_temp/logo?g" $basedir/.html_temp/2back.t
sed -i "6 s/\\//\\\\/g" $basedir/.html_temp/1head.t
sed -i "8 s/\\//\\\\/g" $basedir/.html_temp/1head.t
sed -i "2 s/\\//\\\\/g" $basedir/.html_temp/2back.t
cat $basedir/.html_temp/1head.t > index.html

#讀取工作目錄以內有多少個資料夾，以此做徊圈，並建立各資料夾內的index.html檔
i=$(ls -lR | grep "^d" | wc -l)
j=0
until [ $i = 0 ]
do
        case $j in
                0)
			#這裡是為了建立html的基本資料，j=0的情況僅建立basedir的index.html。
                        (ls -cl|grep "^d"|cut -d ':' -f 2|cut -d ' ' -f 2) > temp.tt
			#這段是為了讀取資料夾名稱
                        f=$(ls -l | grep "^-" | wc -l)
			#讀取檔案數量
                        file=temp.tt
                        while read line
                        do
				#進入第二層資料夾作index.html
				li=$(echo $line|cut -d '.' -f 2)
				echo "<li><a href="`pwd`/$line/index.html">$li</a></li>" >> index.html
				echo "<p><a href="`pwd`/$line/index.html">$line</a></p>" >> link.temp
				cd $line
                                pwd >> "$basedir/dir.tt"
                                pwd >> "$basedir/back.log"
                                (ls -l|grep "^-")  >> "$basedir/back.log"
                                f=$(echo $f+$(ls -l | grep "^-" | wc -l)|bc)
				
                                cd $basedir
                        done < $file
			echo '<li style="float:left"><p style="color:red">淡水河北側沿河平面道路工程資料庫</p></li></ul></nav>' >> index.html
			cat $basedir/.html_temp/3mid.t >> index.html
			cp index.html $basedir/.html_temp/2head.t1
			cat link.temp >> index.html
			cat $basedir/.html_temp/2back.t >> index.html
			((j++))
                        rm temp.tt > /dev/null 2>&1
			rm link.temp > /dev/null 2>&1			
                        ;;
                *)
			#其它層的資料夾可以統一處理。
                        ((j++))
                        workdir=$(sed -n "$j"p "$basedir/dir.tt")
                        cd $workdir
            
			n=$(ls -l|grep "^d"|wc -l)
			#判斷目前資料夾中有無其它資料夾，且回傳的是資料夾的數量。
                        if [ $n = 0 ]
			#沒有資料夾的話，直接呼叫函數建立index.html檔。
			then
				makelink $workdir
				cd $workdir
				((i--))
                        else
				#有資料夾的話，就要進入該資料夾再建立index.html檔，目前我覺得這腳本的方法很笨，也就是會重複幫同一資料夾建檔，但因為電腦處理很快，所以目前還不是問題。                                
				(ls -cl|grep "^d"|cut -d ':' -f 2|cut -d ' ' -f 2) > temp.tt
                                file=temp.tt
                                while read line
                                do                                      
					makelink $workdir
					cd $line                               	
                                        pwd >> "$basedir/dir.tt"
					makelink $workdir/$line
					((i--))
 					cd ..
                                done < $file
                                rm *.tt > /dev/null 2>&1

                        fi
                        ;;
        esac
done
cd $basedir
echo `pwd`
echo "dir:$(ls -lR | grep "^d" | wc -l) ,file:$f"


