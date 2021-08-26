#include<stdio.h>
#include<stdlib.h>
#include<time.h>
int main()
{
	int k,m,h,i;
	float s1,s2,s3;
	i=1;
	k=5;
	h=800;
	s1=2;
	srand(time(NULL));
	s2=(rand()%k)+0;
/*	srand(time(NULL));*/
	s3=((rand()%h)+30);
	printf("%d,%fk%fm,%fcm\n",i,s2,s1,s3);
	
}

