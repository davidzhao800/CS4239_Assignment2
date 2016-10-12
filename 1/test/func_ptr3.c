#include <stdio.h>

int f(int i){
	return i++;
}

int g(int i){
	return ++i;
}
int x(int i){
	return i*2;
}


int h(int c){
	c+=x(c);
	return (int)c;	
}

int y(int i){
	return f(i) + g(i) + x(i) + y(i) + h(i);
}

int main(){
	int i = 0, counter = 0;
	int (*ptr)(int);
	
	for (counter = 0; counter<100; counter++){
		scanf("%d",&i);
		while (i!=0){
			if (i>0){
				ptr = f;
				if (i>100){
					ptr = g;
				}
				else {
					ptr = h;
				}
			}

			else{
				ptr = g;
			}

			ptr(256);
			i++;
		}
	}
}
