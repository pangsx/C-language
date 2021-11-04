#!/bin/bash
#1101026因為我的監視器產生的檔案多太了，所以產生二個問題，一個是我原本的腳本沒辦法處理，第二個問題是我沒時間常去備份下來，我懶，所以在這我想要寫一個自動下載我自己FTP內檔案的腳本。

clear
#下面這行輸入ftp的資關資料，格式是採用wget可以使用的，然後再分解出主機，帳戶和密碼。
#ftpadd='ftp://pangsx:%pang2home&@192.168.0.2/110/dcs931l'
ftpadd='ftp://pang:pp@192.168.43.3/dcs931l/.'
ftpadd2=$(echo $ftpadd|cut -d '@' -f 2|cut -d '/' -f 1)
usern=$(echo $ftpadd|cut -d ':' -f 2|cut -d '/' -f 3)
passw=$(echo $ftpadd|cut -d ':' -f 3|cut -d '@' -f 1)
#用wget下載回來很方便，就下面這一行。
wget -r -nH -nc $ftpadd
#先把ftp根目錄下面的格案刪光，因為要用被動模式才能正確的操作，所以要加上-p參數，而在下mdelete指令時，不用-i參數的話，每個檔被刪都會問你確不確定，所以要加-i，如果你想一個一個回，那還用腳本做什麼。
cd dcs931l
ftp -v -n -p -i  $ftpadd2 <<EOF
user $usern $passw
cd dcs931l
mdelete *
bye
EOF
#因為要去ftp server上的資料夾，所以我要建立資料夾的清單，然後就按清單登入，進入目錄，刪檔，退出目錄，刪目錄，退出。
(ls -l | grep "^d"|cut -d : -f 2|cut -d " " -f 2) > dfile.db
file=dfile.db
while read line;do
	ftp -v -n -p -i $ftpadd2 <<EOF
user $usern $passw
cd dcs931l
cd $line
mdelete *
cd ..
rmdir $line
bye
EOF
done < $file
rm dfile.db
