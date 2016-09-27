#include <string>
#include <sstream>

#ifndef MESSAGES_H
#define MESSAGES_H
using namespace std;
class Messages {
public:
	static const string COMMON_ERROR_HEADER;
	static const string ERROR_MAIN_NO_IR_FILE;
	static const string ERROR_IRREADER_FAIL_READ;

	static string formatErrorMessage(string message);
	static string formatErrorMessage(string message, string name);
};
#endif
