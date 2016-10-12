char b = 'c';
char *globalptr;

void void_return() {
    char array[10];
    char local_char = 'a';
    char *p;
    int i =0;
    while(i){
    	p = array+2;
	int j = 1;
	if (j) {
		globalptr = &local_char;
	} else {
		p = &b;
	}
    } 
}

//escape: yes

int return_int() {
    char local_char = 'a';
    globalptr = &local_char;
    globalptr = &b;
    return 0;
}
