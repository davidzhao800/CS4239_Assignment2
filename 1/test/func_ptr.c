#include <stdio.h>

int f(){
	return 1;}

	int main(){
		int (*ptr)(void) = &f;
		printf("%d\n",ptr());
	} 
