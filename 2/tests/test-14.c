/* This test file contains several tests:
 *
 * two_return()
 * nested_while()
 * nested_if()
 * nested_if_while()
 * nested_while_if_with_multiple_return()
 * adjacent_if_while_with_multiple_return()
 *
 * */
char b = 'c';
int c = 1;
char global_array[10];

char *two_return() {
	char local_char = 'a';
	char *p = &local_char;
	char *p2 = &local_char;
	int i = 0;
	if (i) {
		// escape
		return p;
	}
	p2 = &b;
	// not escape
	return p2;
}

int *nested_while() {
	int i = 0;
	int j = 1;
	int *p;
	while (i) {
		p = &j;
		while (j) {
			p = &c;
		}
	}
	//escape
	return p;
}

int *nested_if() {
	int i = 0;
	int j = 1;
	int *p;
	if (i == j) {
		p = &c;
		if (j) {
			p = &j;
		}
	}
	// escape
	return p;
}

char *nested_while_if() {
	char local_array[10];
	char *p;
	int i;
	while (i) {
		p = global_array;
		if (i) {
			p = local_array;
		}
	}
	//escape
	return p;
}

char *nested_while_if_multiple_return() {
	char local_array[10];
	char local_char = 'a';
	char *p = &local_char;
	char *p2 = global_array;
	int i =0;
	while (*p == 'a') {
		if (i) {
			p = local_array;
			// escape
			return p;
		} else {
			//not escape
			return p2;
		}
	}
	// escape
	return p;
}

char *adjacent_if_while_with_multiple_return() {
	char i = 'b';
	char *p;
	int j = 0;
	if (j) {
		// not escape
		return p;
	}
	while (j==0) {
		p = &i;
	}
	if (j) {
		p = &b;
		// not escape
		return p;
	}
	// escape
	return p;
}
