#include "Messages.h"

const string Messages::COMMON_ERROR_HEADER = "Error: ";
const string Messages::ERROR_MAIN_NO_IR_FILE = "IR file not specified.";
const string Messages::ERROR_IRREADER_FAIL_READ = "fail to read IR file: ";
const string Messages::IRREADER_READ_FILE = "Reading File: ";

string Messages::formatErrorMessage(string message) {
	stringstream ss;
	ss << COMMON_ERROR_HEADER << message;
	return ss.str();
}

string Messages::formatErrorMessage(string message, string name) {
	return formatErrorMessage(
		formatMessage(message, name));
}

string Messages::formatMessage(string message, string name) {
	stringstream ss;
	ss << message << name;
	return ss.str();
}
