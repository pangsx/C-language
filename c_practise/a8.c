#include <stdio.h>
//輸出1～100的數據，以10x10方式1100416
int main()
{
	int i,j,n,k,c,d;
	//printf("input you want line:");
	//scanf("%d",&n);
	for (i=1;i<=10;i++)
	{
		n=i;
		for(j=1;j<=10;j++)
		{
			printf("%d ",n);
			n+=10;
		}
		printf("\n");
	}

	return 0;
}
