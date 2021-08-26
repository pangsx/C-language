#include <stdio.h>
//畫三角形1100412
int main()
{
	int i,j,n,k,c,d;
	printf("input you want line:");
	scanf("%d",&n);
	for (i=1;i<=n;i++)
	{
		for(j=1;j<=i;j++)
		{
			printf("* ");
		}
		printf("\n");
	}
	//倒三角
	printf("\n");
		for (i=n;i!=0;i--)
	{
		for(j=1;j<=i;j++)
		{
			printf("* ");
		}
		printf("\n");
	}	
	//用數字
	printf("\n");
		for (i=1;i<=n;i++)
	{
		for(j=1;j<=i;j++)
		{
			printf("%d ",j);
		}
		printf("\n");
	}
	//用字母
	printf("\n");
	char a,b;
	a='A';
	if(n==1){b='A';};
	if(n==2){b='B';};
	if(n==3){b='C';};
	if(n==4){b='D';};
	if(n==5){b='E';};
	if(n==6){b='F';};
	if(n==7){b='G';};
	if(n==8){b='H';};
	if(n==9){b='I';};
	if(n==10){b='J';};
	if(n==11){b='K';};
	if(n==12){b='L';};
	if(n==13){b='M';};
	if(n==14){b='N';};
	if(n==15){b='O';};
	if(n==16){b='P';};
	if(n==17){b='Q';};
	if(n==18){b='R';};
	if(n==19){b='S';};
	if(n==20){b='T';};
	if(n==21){b='U';};
	if(n==22){b='V';};
	if(n==23){b='W';};
	if(n==24){b='X';};
	if(n==25){b='Y';};
	if(n==26){b='Z';};
		for (i=1;i<=(b-'A'+1);i++)
	{
		for(j=1;j<=i;j++)
		{
			printf("%c ",a);
		}
		++a;
		printf("\n");
	}
	//金字塔
	printf("\n");
	for (i=1;i<=n;i++,j=0)
	{
		for (k=1;k<=n-i;k++)
		{
			printf("  ");
		}
		for(j=0;j!=2*i-1;j++)
		{
			printf("* ");
		}
		printf("\n");
	}
	//數字金字塔
	printf("\n");
	c=0;
	d=0;
	for (i=1;i<=n;i++)
	{
		for (k=1;k<=n-i;k++)
		{
			printf("  ");
			++c;
		}
		//printf("%d",c);
		for(j=0;j!=2*i-1;j++)
		{
			if(c<=n-1)
			{
				printf("%d ",i+j);
				++c;
			}
			else
			{
				d++;
				printf("%d ",(i+j-2*d));
			}
		}
		c=0;
		d=0;
		printf("\n");
	}
	//弗洛依德三角形
	d=1;
	printf("\n");
	for (i=1;i<=n;i++)
	{
		for(j=1;j<=i;j++)
		{
			printf("%d ",d);
			d++;
		}
		printf("\n");
	}
	


	return 0;
}
