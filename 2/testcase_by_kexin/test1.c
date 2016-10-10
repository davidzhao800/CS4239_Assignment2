#include <stdio.h>
#include <stdlib.h>

int* f();

int main(int argc, char** argv){
	printf("%d\n",*f());
}

int* f(){
	int* num = malloc(sizeof(int));
	*num = 1;
	int** p = &num;
	return *p;
}
