#include <stdio.h>

int g(){
	return 0;
}

void f(){
	printf("Hello World\n");
	g();
}

/*
int main(){
	int i;
	f();
	if (i==0){
		i = 5;
	}
	else {
		i = 10;
	}
}
*/

int h(){
	return 1;
}
