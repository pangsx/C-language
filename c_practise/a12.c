#include <stdio.h>
#define new 127 //定義ASCII最大值

int main()
{
	int i,s;
	s=1;
	char c[new];
	for(;s>0;){
		printf("input 1 ASCII==>word\ninput 2 word==>ASCII\ninput 0 stop\n");
		scanf("%d",&s);
		printf("input sometiong less %d:\n",new);
		scanf("%s",c);
		if(s==1)
		{
			for(i=0;c[i];i++){printf("%d is word '%c'\n",c[i],c[i]);}
		}
		if(s==2)
		{
			for(i=0;c[i];i++){printf("%c is ASCII '%d'\n",c[i],c[i]);}
		}
		else
		{
			printf("byebye");
		}
		return 0;
	}
}


