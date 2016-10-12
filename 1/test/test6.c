#include "stdio.h"
void bar() {
	printf("hello world");
}

void foo() {
	bar();
}


int main() {
	int i = 1;
	while (i) {
		bar();
	}
	return 0;
}
