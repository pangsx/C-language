#include <stdio.h>
#define new 65535 //定義最大值

int main()
{
	char c[new];
	printf("input some one less %d:\n",new);
	scanf("%s",c);
	for(int i=0;c[i];i++)
	{
	printf("%c ASCII is %d\t\n",c[i],c[i]);
	}
	return 0;
}

