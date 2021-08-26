#include <stdio.h>
int main()
{
	int i,j;
	printf("input number of you want:\n");
	scanf("%d",&i);
	int s,s1,s2;
	s1=0;
	s2=1;
	for(j=1;j<=i;j++)
	{
		printf("%d,",s1);
		s=s1+s2;
		s1=s2;
		s2=s;
	}
	return 0;
}



