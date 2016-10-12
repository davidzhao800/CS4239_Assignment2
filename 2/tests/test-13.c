char b = 'c';
char *globalptr;

char *escape_local() {
    char local_char = 'a';
    char *p = &local_char;
    char *p2 = &local_char;
    char array[10];
    int i=0;
    if (i) {
	return p;
    }
    globalptr = array;
    p2 = &b;
    return p2;
}

