#include <stdio.h>
//判斷是否為回文數(ex.1234321)1100412
int main()
{
	int n,c,i,j;
	printf("input you nimber:");
	scanf("%d",&n);
	//判斷n是幾位數(我自己寫的程式是可行的，但抵不過一行程式就求出了)
	//int d,x;
	//d=10;
	//x=1;
	//for (i=0;x!=0;i++)
	//{
	//	x=n/d;
	//	d=d*10;
	//	printf("you input %d,",x);
	//}
	//i=n%10;
	//printf("you input %d\n",i);
	j=n;
	c=0;
	while(n!=0)
	{
		i=n%10;
		c=c*10+i;
		n /=10;
		printf("%d,%d,%d\n",i,n,c);
	}

	return 0;
}



