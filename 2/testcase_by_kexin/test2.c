#include <stdio.h>
#include <stdlib.h>

int* f(){
	int x = 0;
	int* ptr_x = &x;
	int* ptr_y = malloc(sizeof(int));
	ptr_x = ptr_y;
	return ptr_x;
}

int* g(){
	int array[100];
	int* p = array;
	int i;
	for (i = 0; i < 10; i++){
		if (i>10){ 
			p = NULL;
		}
	}
	return p;
}


int main(int argc, char** argv){
	printf("%d\n",*f());
	printf("%d\n",*g());
}


