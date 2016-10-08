char b = 'c';

char *escape_local() {
    char local_char = 'a';
    char *p = &b;
    int i =0;
    while(i){
    
    	p = &local_char;
    } 
    return p;
}

//escape: yes
