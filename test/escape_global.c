char *globalptr;
void escape_global(char **argptr, char *aChar, int aInt) {
	char array[10];
	char x = 'a';
	int i;
	while (i) {
		globalptr = array;
		*argptr = array;
	}
	if (i) {
		globalptr = &x;
		*argptr = &x;
	}
}
