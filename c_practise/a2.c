#include <stdio.h>
#include <math.h>


int main()
{
	float a,b,c,x1,x2,d;
	printf("input a,b,c:\n");
	scanf("%f %f %f",&a,&b,&c);
	if (a!=0)
	{
		d=sqrt(b*b-4*a*c);
		x1=(-b+d)/(2*a);
		x2=(-b-d)/(2*a);
		if(x1<x2)
			printf("%f %f",x2,x1);
		else
			printf("%0.3f %0.3f",x1,x2);
	}
	return 0;
}




