因為工作需求（也不算是，個人硬加入的理由），我想要建制一套系統，有關於紀錄營造工程所需表單與工程過程中品管文件的紀錄、管控等工作，所以我想利用ubuntu的系統幫我做到以下工作：
1.FTP或SSH，用以上傳工作的文件和照片。
2.apache、Mysql、php用來展示照片及品管文件。
3.各工作人員間的帳號管理工作。

但是這些我都沒有經驗，惟一的優勢是可能會接淡北道路這個大案子，所以廠商、監造會比較長期在工務所，應該是比較有機會達成的，好了不廢話了，
這邊是要紀錄第2項工作的測試紀錄。

1100722
總結一下安裝過程

sudo apt-get install tasksel
sudo apt-get update && sudo apt-get upgrade
sudo tasksel
除了預選的再多加LAMP server
開始安裝ok

參考下列網址設定mysql
https://www.peterdavehello.org/2019/12/set-mysql-password-login-and-create-database-on-ubuntu-18-04-and-later/
mysql的語法我沒有很想要學，雖然之前我學過，但最近學太多，我累了，主要是設定root的密碼和設一個私人的帳號，建立之後要用的資料庫，並把權限設個私人帳號，網頁教學很詳盡。

安裝一些php要用的擴充功能
sudo apt-get install php7.4-mbstring
sudo apt-get install php7.4-xml
sudo apt-get install php7.4-json

php.ini修改
short_open_tag = 1
extension=mbstring
extension=mysqli

下載最新的gallery3，解壓並移到apache2的預設路徑下(/var/www/html/)，這部分指令我就不打了
到gallery3的目錄下
mkdir var
chmod 777 var
rm php.ini
cd installer
sudo vim installer.php
改第120行，把mysql_fetch_object改成mysqli_fetch_object,

打開瀏覽器
127.0.0.1/gallery3/index.php
應該可以依指示安裝完成了，另外要安裝一些外掛module功能。
使用心得就不在此說明了。

1100727
更新一下，無論是本機或是網路連線，都看不到預覽圖啊，這樣沒辦法符合目標啊QQ
安裝另一個方案的時候發現了解決問題的方法，紀錄一下，這個程式在圖形處理設定時，有三個選項可以讓你去選擇，分別是
ImageMagick、GD和GraphicsMagick，這三個方案，先說明一下他們是什麼功用，主要是上傳後，php程式會在同時幫你製作縮圖，而這個縮圖即是作預覽用的，沒有這個縮圖，自然是在網站上看不到預覽，而我一開始是選擇了GraphicsMagick方案，所以安裝程序就讓我過了，但沒想到他並不能執行原本想要達到的功能，原因為何我不知道，而我找到的另一個相本也可以選用ImageMagick和GD，這次我選了ImageMagick方案，結果還是不能用，我確認是安裝完成了，所以只好用GD方式，經過測試也只有GD可以用，而且他安裝的方式最為簡便，二行指令：
sudo apt-get install php7.0-gd
sudo apt-get install php-gd
sudo reboot
要發揮功用需要重開機一下，現在我可以看到縮圖了，要來研究這個相本的外掛了。

1100729
Gallery3FolderSyncModule
這是一個能自動把伺服器上的資料夾轉成相本給gallery3使用的外掛，安裝上有一些步驟，紀錄一下，並且將問題也紀錄下來，官網的說明網址如下：
http://codex.gallery2.org/Gallery3:Modules:folder_sync
其中第二步要做以下的事

ps axo user,group,comm | egrep '(apache|httpd)'
sudo crontab -u www-data -e
選一個順手的編輯器，加入下行
30 * * * * php /var/www/html/gallery3/modules/Gallery3FolderSyncModule/cron.php
存檔，退出

現在碰到的問題是第三步有說要去設定資料夾位置，但是我的網頁沒有顯示FolderSync的選項。
因為我下載的目標是Gallery3FolderSyncModule，但觀察官網說明，他給的路徑是30 * * * * php /path/to/gallery3/modules/folder_sync/cron.php
所以我推測是要把資料夾名稱改成folder_sync才行，改完後順便要把第二步的路徑修正如下:
30 * * * * php /var/www/html/gallery3/modules/folder_sync/cron.php
再登入網站，直接就跳出要我設定folder_sync了



＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝以下是過程的紀錄＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝










1100714
找到一個網站，說有一個套件tasksel，可以安裝LAMP server。LAMP指的是Linux,Apache,MySQL,PHP
https://peterli.website/%E4%BD%BF%E7%94%A8lubuntu%E6%9E%B6%E8%A8%ADlamp-server%E4%BA%8C%E4%B8%89%E4%BA%8B%E4%B8%80/

sudo apt-get install tasksel
sudo apt-get update && sudo apt-get upgrade
sudo tasksel
除了預選的再多加LAMP server
開始安裝
裝完了，網頁中說會問我Mysql的密碼，但是我沒看到，進入127.0.0.1可以看到預設網頁。

輸入mysql
ERROR 1045 (28000): Access denied for user 'pang'@'localhost' (using password: NO)
這錯誤應該是說我目前的帳號沒有權限

輸入mysql -u root -p
ERROR 1698 (28000): Access denied for user 'root'@'localhost'
說要root才有權限
所以就用root吧
sudo mysql -u root -p
密碼是!QAZxsw2
設完了就進入mysql程式內，表示有裝好


修改apache2的預設文件目錄(預設是在/var/www)(1100720)
sudo gedit /etc/apache2/sites-enabled/000-default
找DocumentRoot 
參考網址
https://codertw.com/%E4%BC%BA%E6%9C%8D%E5%99%A8/381885/

修改php.ini(1100720)
因為要支援short_open_tag以及sate_mod = on所以要修改這個檔，上網找了一下，這個檔案在/etc/php/apache2/php.ini
完成後要重啟apache如下
sudo /etc/init.d/apache2 restart

要安裝一些php擴充
sudo apt-get install php-xml



1100721因為一直錯誤，所以我重新再裝一次
然後我發現了一個笨問題，這次我把gallery3資料夾移到apache預設目錄下(/var/www/html)，然後主頁就會變成127.0.0.1/gallery3，接著我發現資料夾內有一個叫installer，所以移到那就變成127.0.0.1/gallery3/install/，然後安裝的指引就出現了......媽的
用127.0.0.1/gallery3/index.php也會轉跳到安裝畫面

sudo apt-get install php7.4-mbstring
sudo apt-get install php7.4-xml
sudo apt-get install php7.4-json
sudo /etc/init.d/apache2 restart


參考下列網址設定mysql
https://www.peterdavehello.org/2019/12/set-mysql-password-login-and-create-database-on-ubuntu-18-04-and-later/

user name:pangsx
pw:!QAZxsw2
Table prefix:test

php.ini修改
short_open_tag = ON
extension=mbstring

apache2.conf修改加入
<Location "/gallery3/">
AllowOverride All
</Location>

sudo a2enmod rewrite






教你安裝的教學
https://www.linuxhelp.com/how-to-install-gallery3-in-ubuntu



1100721卡在mysql的函數調用不到，參考下網址
mysql_fetch_object
https://ubuntuqa.com/zh-tw/article/7852.html



1100722
今天改了一下/gallery3/installer/installer.php的第120行，把mysql_fetch_object改成mysqli_fetch_object,
並把/etc/php/7.4/apache2/php.ini中的mysqli擴展功能開啟(就是把;拿掉)，即完成安裝功能了，但flash play不能用，無法上傳照片。
改用擴充功能http upload來上傳了，但和我預想的有些不一樣。






















