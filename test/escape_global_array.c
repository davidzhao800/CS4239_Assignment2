char *globalptr;
void escape_local2(char **argptr, char *aChar, int aInt) {
	char array[10];
	globalptr = array;
	*argptr = array;
}