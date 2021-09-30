#!/bin/bash
#1100806組合網頁的腳本，測試中。
#1100831基本上是己經完成，但是細節要進行測試，也要幫腳本建立註解，不然寫了太久會不知道自己在寫什麼。
#1100924加入刪資料夾及檔名空格的功能，程式是抄別人的，高手寫的太強大了，會把空格轉成－
#1100930修改程式變成相對路徑的版本，這樣才可以跨電腦使用。
#function
#以下是建立捷徑和index.html的函數。
makelink(){
	rm *.html > /dev/null 2>&1
	rm 0 > /dev/null 2>&1
	(ls -l|grep "^-")  >> "$basedir/back.log"
	f=$(echo $f+$(ls -l | grep "^-" | wc -l)|bc)
	cp $basedir/hhead $1/index.html
	#cd ..	
	#為了做back捷徑，所以需要知道上一層目錄
	#我後來知道，可以用../取代上一層，所以上面這些步驟就變成多餘的了。
	#cd $1
	echo "<h1><a href="../index.html">back</a></h1>" >> $1/index.html
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
			echo "<h1><a href="`pwd`/$line2/index.html">$line2</a></h1>" >> $1/index.html
		done < $file2
	fi
	rm $1/*.tt > /dev/null 2>&1
	#判斷有沒有jpg,png,gif以外的檔案，有就幫它做連結。
	check=$(ls -cl|grep "^-"|grep -v .jpg|grep -v .png |grep -v .gif|grep -v .html|wc -l)
	if [ $check = 0 ]
	then
		check=0
	else	
		rm $1/*.tt > /dev/null 2>&1
		#(ls -cl|grep "^-"|grep -v .jpg|grep -v .png |grep -v .gif|grep -v .html|grep -v .tt|cut -d ':' -f 2|cut -d ' ' -f 2) > $1/ftemp.tt
		(for filename in *.*;do echo $filename;done|grep -v .jpg |grep -v .png|grep -v .gif|grep -v .tt|grep -v .html) > $1/ftemp.tt
		file2=$1/ftemp.tt
		while read line2
		do
			echo "<p><a href="`pwd`/$line2">$line2</a></p>" >> $1/index.html
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
			echo "<div class="img"><a target="_blank" href="`pwd`/$line2"><img src="$line2" width="300" height="200"></a><div class="desc">$line2</div></div>" >> index.html
		done < $file2
	rm $1/*.tt > /dev/null 2>&1
	fi
	cat $basedir/hback >> $1/index.html
	#1100927為了把這個腳本變成相對路徑的方式，所以補充了下面的這段程式，發現這個專案程式越來越多行，我快要不行了。
	echo $1 > d.tt
	sed -i s?\\/?\\\\/?g d.tt
	reone=$(cat d.tt)\\/
	#1100930因為要改的字串有特殊字元，所以上面幾行在作特殊字元的轉換，好讓shell看的懂。
	rm d.tt > /dev/null 2>&1
	#echo $1 >> d.tt
	sed -i s/$reone//g $1/index.html
	sed -i s/$rebasedir//g $1/index.html
	#轉換好就可以做字串的替換了，以上幾行是替換。
	ndir=$(echo $1|grep -o /|wc -l)
	ndir=$(echo "$ndir-$cdir"|bc -l)
	#因為導行列的相對路徑和一般連結不一樣，要用../來回去上一層，或上幾層，看要回去幾層，就要有幾個../，而且又有特殊字元，所以上面幾行在計算，基礎目錄到工作目錄間，需要幾個../
	str=../
	unset -v str1
	for dirr in $(seq 1 $ndir)
	do
		str1=$str1$str
	done
	echo $str1 > str.tt
	sed -i s?\\/?\\\\/?g str.tt
	str1=$(cat str.tt)
	#知道要幾個../就可以做迴圈，並處理特殊字元。
	sed -i "19 s/\.\//$str1/g" index.html
	sed -i "20 s/\.\//$str1/g" index.html
	sed -i "21 s/\.\//$str1/g" index.html
	#結束的圖也要做連結，所以下面會找到需要的行數，再做替換，但是要注意，未來如果要加設計或廠商的圖或字，這部份就要看看有沒有要調整。
	logo=$(grep -n \<footer\> index.html|cut -d ":" -f 1)
	sed -i "$logo s/\.\//$str1/g" index.html
	rm str.tt
return 1	
}
#1100923網路上抄來的去除空格程式，超讚
killspace()
{
startDir=.
for arg in "$@" ; do
find $startDir \( -name "* *" -o -name "* *" \) -print |
while read old ; do
new=$(echo "$old" | tr -s '\011' ' ' | tr -s ' ' '-')
mv "$old" "$new"
done
done
return 1
}


#main
rm *.tt > /dev/null 2>&1
rm *.t > /dev/null 2>&1

basedir=$(pwd)
cdir=$(echo $basedir|grep -o /|wc -l)
echo $basedir > dir.t
#1100927
cp dir.t ddir.tt
sed -i s?\\/?\\\\/?g ddir.tt
rebasedir=$(cat ddir.tt)\\/
rm ddir.tt > /dev/null 2>&1

rm index.html > /dev/null 2>&1
#這段是在建立index.html所需要的css和標題等檔頭文件。
#cp $basedir/.html_temp/head.t $basedir/.html_temp/1head.t
#cp $basedir/.html_temp/back.t $basedir/.html_temp/2back.t
#basedir是腳本所在的目錄，接下來會把此路徑寫入所需的暫存文件中
#sed -i "s?up?$basedir/.html_temp/up?g" $basedir/.html_temp/1head.t
#sed -i "s?photo?$basedir/.html_temp/photo?g" $basedir/.html_temp/1head.t
#sed -i "s?logo?$basedir/.html_temp/logo?g" $basedir/.html_temp/2back.t
#sed -i "6 s/\\//\\\\/g" $basedir/.html_temp/1head.t
#sed -i "8 s/\\//\\\\/g" $basedir/.html_temp/1head.t
#sed -i "2 s/\\//\\\\/g" $basedir/.html_temp/2back.t
#cat $basedir/.html_temp/1head.t > index.html

#1100927因為絕對路徑只能在我自己的電腦上執行，不能在其它電腦執行，一般來說，解決的方法應該是透過網路，把css檔放在某固定網址，但是我的目的是不必透過網路，這樣子在佈建上比較方面，所以我要改掉css這部分。
touch hhead
echo '<!DOCTYPE html>' >> hhead
echo '<html>' >> hhead
echo '<head>' >> hhead
echo ' <title>淡北道路</title>' >> hhead
echo '<style>' >> hhead
echo 'body {margin:0;}' >> hhead
echo 'ul {    list-style-type: none;    margin: 0;    padding: 0;    overflow: hidden;    background-color: #333;    position: fixed;    top: 0;    width: 100%;}' >> hhead
echo 'li {    float: right;}' >> hhead
echo 'li a {    display: block;    color: white;    text-align: center;    padding: 14px 16px;    text-decoration: none;}' >> hhead
echo 'li a:hover:not(.active) {    background-color: #111;}' >> hhead
echo 'div.img {    margin: 5px;    border: 1px solid #ccc;    float: left;    width: 180px;}' >> hhead
echo 'div.img:hover {    border: 1px solid #777;}' >> hhead
echo 'div.img img {    width: 100%;    height: auto;}' >> hhead
echo 'div.desc {    padding: 15px;    text-align: center;}' >> hhead
echo '</style>' >> hhead
echo '</head>' >> hhead
echo '<body>' >> hhead
echo '<nav class="menu"><ul>' >> hhead

touch hback
echo '<div id="footer" style="position:fixed; bottom:0px; height:70px; left:0px; right:0px; overflow:hidden;">' >> hback
echo '<footer><img src="./.html_temp/logo.jpg" with="600" heigh="400" alt="新建工程處"></footer></div>' >> hback
echo '</body>' >> hback
echo '</html>' >> hback

touch hmid
echo '<div style="padding:20px;margin-top:30px;background-color:#1abc9c;height:1500px;">' >> hmid


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
			cp hhead index.html
                        while read line
                        do
				#進入第二層資料夾作index.html
				killspace d f
				li=$(echo $line|cut -d '.' -f 2) 
				echo "<li><a href="./$line/index.html">$line</a></li>" >> index.html
				echo "<p><a href="./$line/index.html">$line</a></p>" >> link.temp
				cd $line
				killspace d f
                                pwd >> "$basedir/dir.t"
                                pwd >> "$basedir/back.log"
                                (ls -l|grep "^-")  >> "$basedir/back.log"
                                f=$(echo $f+$(ls -l | grep "^-" | wc -l)|bc)	
                                cd $basedir
                        done < $file
			echo '<li style="float:left"><p style="color:red">台2線台電161KV管遷工程資料庫</p></li></ul></nav>' >> index.html
			cat $basedir/hmid >> index.html
			cp index.html hhead
			cat link.temp >> index.html
			cat $basedir/hback >> index.html
			((j++))
                        rm temp.tt > /dev/null 2>&1
			rm link.temp > /dev/null 2>&1	
			#1100927
			#sed -i s/$rebasedir//g index.html
                        ;;
                *)
			#其它層的資料夾可以統一處理。
                        ((j++))
                        workdir=$(sed -n "$j"p "$basedir/dir.t")
                        cd $workdir
			killspace d f
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
					killspace d f
                                        pwd >> "$basedir/dir.t"
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
rm hhead hback hmid
echo "dir:$(ls -lR | grep "^d" | wc -l) ,file:$f"


