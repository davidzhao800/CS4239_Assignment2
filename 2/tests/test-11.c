char b = 'c';

char *escape_local() {
    char local_char = 'a';
    char *p = &local_char;
    p = &b;
    return p;
}

//escape: no
