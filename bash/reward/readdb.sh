#!/bin/bash
readdb(){
#echo "readdb now"
file=$1
while read line
do
	case $2 in
		1)
			j=0
			for i in {1..9}
			do
				reward[$j]=$(echo $line|cut -d ',' -f "$i")
				j=i
			done
			okk=okh.txt
			if [ ${reward[9]} -le 8 ] && [  -n ${reward[9]} ]
			then
				for i in {3..8}
				do
					if [ ${reward[$i]} -le 38 ] && [  -n ${reward[$i]} ]
					then
						:
					else
						echo "check input"
						exit 2
					fi
				done
			else
				echo "check input"
				exit 1
			fi
			./happyreward.sh ${reward[0]} ${reward[3]} ${reward[4]} ${reward[5]} ${reward[6]} ${reward[7]} ${reward[8]} ${reward[9]}
			;;
		2)
			j=0
			for i in {1..8}
			do
				reward[$j]=$(echo $line|cut -d ',' -f "$i")
				j=i
			done	
			okk=okb.txt
			for i in {3..8}
			do
				if [ ${reward[$i]} -le 49 ] && [  -n ${reward[$i]} ]
				then
					:
				else
					echo "check input"
					exit 2
				fi
			done
			./bigreward.sh ${reward[0]} ${reward[3]} ${reward[4]} ${reward[5]} ${reward[6]} ${reward[7]} ${reward[8]} ${reward[9]}
			;;
		*)
			echo "need select what do you want to reward."
			;;
	esac 
	bonus=$(cat temp.db)
	if [ $bonus = notyet ]
	then
		echo $line >> notyet.txt
	else
		echo $line,$bonus >> $okk
	fi
	sed -i 1d $1
	rm temp.db
done < $file
if [  -f notyet.txt ]
then
	rm $1
	mv notyet.txt $1
	rm notyet.txt
else
	echo "work over"
fi
}
readdb $1 $2
