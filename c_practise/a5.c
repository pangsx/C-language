#include <stdio.h>
//輸出九九乘法表1100412
int main()
{
	int i,j;
	i=0;
	for (i=1;i<=9;i++)
	{
		j=0;
		for (j=1;j<=9;j++)
		{
			printf("%dx%d=%d,",i,j,(i*j));
		}
		printf("\n");
	}

	return 0;
}



