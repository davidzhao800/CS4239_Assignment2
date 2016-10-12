#include <stdio.h>
#include <stdlib.h>

char b = 'c';
char *globalptr;
char* global_char_ptr;
int global = 1;

void sample_test(char **argptr) {
    char local_char = 'a';
    char array[10];
    *argptr = &local_char;
    globalptr = array;
}

void sample_test2(char **argptr, char *aChar, int aInt) {
    char local_char = 'a';
    char array[10];
    *argptr = array;
    globalptr = &local_char;
}

void global_local_pointer_same() {
    char local_char = 'a';
    char *p2 = &local_char;
    char *p3;
    char *p4;
    char *p;
    int i = 0;
    if (i) {
        p3 = p2;
    }
    while (i) {
        p4 = p3;
    }
    p = p4;
    globalptr = p;
}

void something_realated_to_switch_array(char **argptr) {
    char local_array[10];
    int i;
    switch(i){
	case 1:
		globalptr=&local_array[2];
		break;
	case 2:
		*argptr=local_array+1;
		break;
	default:
		break;
    }
} 


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


