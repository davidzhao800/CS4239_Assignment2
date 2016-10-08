#include "stdlib.h"

void foo() {
	printf("foo called");
}

void bar() {
	printf("bar called");
}

int main() {
	int i = 1;
	if (i) {
		foo();
	} else {
		bar();
	}
	return 1;	
}
