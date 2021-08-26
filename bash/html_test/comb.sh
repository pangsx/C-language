#!/bin/bash
#1100806組合網頁的腳本，測試中。
#function
makelink(){
	rm *.html > /dev/null 2>&1
	rm 0 > /dev/null 2>&1
	(ls -l|grep "^-")  >> "$basedir/back.log"
	f=$(echo $f+$(ls -l | grep "^-" | wc -l)|bc)
	cp $basedir/.html_temp/2head.t1 $1/index.html
	cd ..
	backdir=`pwd`
	cd $1
	echo "<h1><a href="$backdir/index.html">back</a></h1>" >> $1/index.html
	checkdir=$(ls -l|grep "^d"|wc -l)
	if [ $checkdir != 0 ]
	then
		rm *.tt > /dev/null 2>&1
		(ls -l|grep "^d"|cut -d ':' -f 2|cut -d ' ' -f 2) > $1/ftemp.tt
		file2=$1/ftemp.tt
		while read line2
		do
			echo "<h1><a href="`pwd`\\$line2\\index.html">$line2</a></h1>" >> $1/index.html
		done < $file2
	fi
	rm *.tt > /dev/null 2>&1
	check=$(ls -cl|grep "^-"|grep -v .jpg|grep -v .png |grep -v .gif|grep -v .html|wc -l)
	if [ $check = 0 ]
	then
		check=0
	else
		rm *.tt > /dev/null 2>&1
		(ls -cl|grep "^-"|grep -v .jpg|grep -v .png |grep -v .gif|grep -v .html|cut -d ':' -f 2|cut -d ' ' -f 2) > $1/ftemp.tt
		file2=$1/ftemp.tt
		while read line2
		do
			echo "<p><a href="`pwd`\\$line2">$line2</a></p>" >> $1/index.html
		done < $file2
	fi
	rm *.tt > /dev/null 2>&1
	photon=$(echo $(ls *jpg|wc -l)+$(ls *png|wc -l)+$(ls *gif|wc -l)|bc)
	if [ $photon > 0 ]
	then
		(ls *jpg) > $1/ftemp.tt
		(ls *png) >> $1/ftemp.tt 
		(ls *gif) >> $1/ftemp.tt
		file2=$1/ftemp.tt
		while read line2
		do
			echo "<div class="img"><a target="_blank" href="`pwd`\\$line2"><img src="$line2" width="300" height="200"></a><div class="desc">$line2</div></div>" >> index.html
		done < $file2
	rm *.tt > /dev/null 2>&1
	fi
	cat $basedir/.html_temp/2back.t >> $1/index.html	
return 1	
}


#main
rm *.tt > /dev/null 2>&1
i=$(ls -lR | grep "^d" | wc -l)
basedir=$(pwd)
echo $basedir > dir.tt
j=0
rm index.html > /dev/null 2>&1
cp $basedir/.html_temp/head.t $basedir/.html_temp/1head.t
cp $basedir/.html_temp/back.t $basedir/.html_temp/2back.t
sed -i "s?up?$basedir/.html_temp/up?g" $basedir/.html_temp/1head.t
sed -i "s?photo?$basedir/.html_temp/photo?g" $basedir/.html_temp/1head.t
sed -i "s?logo?$basedir/.html_temp/logo?g" $basedir/.html_temp/2back.t
sed -i "6 s/\\//\\\\/g" $basedir/.html_temp/1head.t
sed -i "2 s/\\//\\\\/g" $basedir/.html_temp/2back.t
cat $basedir/.html_temp/1head.t > index.html
until [ $i = 0 ]
do
        case $j in
                0)
                        (ls -cl|grep "^d"|cut -d ':' -f 2|cut -d ' ' -f 2) > temp.tt
                        f=$(ls -l | grep "^-" | wc -l)
                        file=temp.tt
                        while read line
                        do
				li=$(echo $line|cut -d '.' -f 2)
				echo "<li><a href="`pwd`/$line/index.html">$li</a></li>" >> index.html
				echo "<p><a href="`pwd`/$line/index.html">$line</a></p>" >> link.temp
				cd $line
                                pwd >> "$basedir/dir.tt"
                                pwd >> "$basedir/back.log"
                                (ls -l|grep "^-")  >> "$basedir/back.log"
                                f=$(echo $f+$(ls -l | grep "^-" | wc -l)|bc)
                                ((i--))
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
                        ((j++))
                        workdir=$(sed -n "$j"p "$basedir/dir.tt")
                        cd $workdir
                        n=$(ls -l|grep "^d"|wc -l)
                        if [ $n = 0 ]
			then
				makelink $workdir
				cd $workdir
                        else                                
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


