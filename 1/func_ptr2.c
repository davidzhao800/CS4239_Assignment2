#include <stdio.h>

int f(int i){
	return i++;
}

int g(int i){
	return ++i;
}

int h(char c){
	return (int)c;
}

int main(){
	int i = 0;
	int (*ptr)(int);

	scanf("%d",&i);
	if (i>0){
		ptr = f;
	}

	else{
		ptr = g;
	}

	ptr(256);
}
