#include <stdlib.h>
char global_array[10];
char *init_array(void) {
	char *heap = malloc(10);
	char array[10];
	char *p;
	int i = 1;
	if (i == 1) {
		p = array;
		return p;
	} else {
		p = global_array;
	}
	while (i) {
		p = "jasidjias";
	}
	return p;
}

