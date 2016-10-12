char *globalptr;
void escape_local2(char **argptr, char *aChar, int aInt) {
	char local_char = 'a';
	int i;
	while (i) {
		globalptr = &local_char;		
	}	
	*argptr = &local_char;
}
