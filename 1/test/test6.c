#include "stdio.h"

void foo() {
	bar();
}

void bar() {
	printf("hello world");
}

int main() {
	int i = 1;
	while (i) {
		bar();
	}
	return 0;
}
