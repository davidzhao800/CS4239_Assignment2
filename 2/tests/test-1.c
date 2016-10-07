char b = 'c';

char *escape_local() {
    char local_char = 'a';
    char *p = &local_char;
    int i =0;
    if(i){
    
    	p = &b;
    } 
    return p;
}

