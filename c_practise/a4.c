#include <stdio.h>
//算幕次的程式1100412
int main()
{
	int i,j,n,a;
	printf("input number of you want:\n");
	scanf("%d",&j);
	//加入是否為零的判斷
	if (j==0)
	{printf("%d",j);}
	else
	{
		n=1;
		for (i=1;i!=(j+1);i++)
		{
			n=n*i;
			printf("%d\n",n);
		}
	}
	return 0;
}



