char b = 'c';

char *escape_local() {
    char array[10];
    char *p = array;
    int i =0;
    if(i){
    
    	p = &b;
    } 
    return p;
}
