char *globalptr;
void escape_local2(char **argptr, char *aChar, int aInt) {
	char local_char = 'a';
	int i;
	if (i) {
		globalptr = &local_char;
	} else {
		*argptr = &local_char;
	}	
}
