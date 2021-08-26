#include<stdio.h>
#include<stdlib.h>
#include<time.h>
int main()
{
	int k,m,h,i;
	//	float s1,s2,s3;
	int s1,s2,s3;
	srand(time(NULL));
	printf("input m:");
	scanf("%d",&m);
	printf("%d\n",m);
	printf("input h");
	scanf("%d",&h);
	printf("%d\n",h);
	printf("input km");
	scanf("%d",&k);
	i=k+1;
	printf("%d\n",k);
	h=h*100-30;
	printf("%d\n",h);
	while(i!=0)
	{
	s2=(rand()%k)+0;
	s3=((rand()%h)+30);
	if(s2==k)
	{s1=(rand()%m+0);}
	else
	{s1=(rand()%1000+0);}
	printf("%d,%dk%dm,%dcm\n",i,s2,s1,s3);
	i--;
	}

}

