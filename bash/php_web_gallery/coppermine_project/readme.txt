官網
https://coppermine-gallery.net/
moible01的教學文
https://www.mobile01.com/topicdetail.php?f=164&t=72839

1100727
有了上次的經驗，這次安裝是快了很多，紀錄一下
git clone https://github.com/coppermine-gallery/cpg1.6.x.git
下載的東西丟到apache的預設目錄下
sudo mv cpg1.6/ var/www/html/
改一下名字會比較好使用，算了
要加php的外掛
sudo apt-get install php7.4-gd
sudo apt-get install php-gd
這樣才會有縮圖的功能
然後去cpg內把以下目錄的權限全改成777
chmod 777 albums
chmod 777 albums/userpics
chmod 777 albums/edit
chmod 777 include

打開chrome或firefox
127.0.0.1/cpg/
會進入網頁安裝指引，一步一步依指示就架好了，
但他有一個問題是，他的目錄內不能再有目錄，這一點我的目的比較難用了，而且我發現原本的那個圖不見的問題改善了，所以回去原方案，這個方案的上傳很方便，先紀錄一下。
