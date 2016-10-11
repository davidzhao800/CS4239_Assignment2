#include <stdio.h>

char* global_char_ptr;
int* global_int_ptr;
int* global_int_ptr2;
int global = 1; 

char* f(){
	char* str = "Hello World";	
	return str;
} 

char* g(){
	char str[20] = "Hello World";
	return str;
}

char* h(int *n){
	char str[20] = "Hello World";
	global_char_ptr = str;
	int i;
	scanf("%d",&i);

	if (i >= 0){
		n = &global;
	}

	else {
		n = &i;
	}

	while (i!=0){
		n = NULL;
		i = 0;
	}
	
	char* str2 = str;
	return str2;
}

void foobar(int* ptr1, int* ptr2){
	int arr[20] = {1,2,3,4,5,6};
	int* arr2 = {1,2,3,4,5,6};
	global_int_ptr = arr;
	global_int_ptr2 = arr2;
	ptr1 = arr;
	ptr2 = arr2;
}

int main(int argc, char** argv){
	printf("%s\n",f());
	printf("%s\n",g());
	h(&argc);
	printf("1\n");
	int* ptr1, *ptr2;
	printf("2\n");
	foobar(ptr1, ptr2);
	printf("3\n");
	printf("%d %d\n",*ptr1,*ptr2); //segfault
}
