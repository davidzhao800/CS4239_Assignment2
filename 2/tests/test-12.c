char b = 'c';

char *escape_local() {
    char local_char = 'a';
    char *p = &local_char;
    char *p2 = &local_char;
    int i=0;
    if (i) {
	return p;
    } else {
	return p2;
    }
}

