char b = 'c';

char *escape_local() {
    char array[10];
    char local_char = 'a';
    char *p;
    int i =0;
    while(i){
    	p = array+2;
	int j = 1;
	if (j) {
		p = &local_char;
	} else {
		p = &b;
	}
    } 
    return p;
}

//escape: yes
