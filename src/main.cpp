#include "IRReader.h"
#include "Messages.h"
#include "EscapeDetect.h"
#include <iostream>
#include <vector>

int main(int argc, char* argv[]) {
	std::vector<std::string> filenameBuffer;
	if (argc <= 1) {
		std::string errorMessage = Messages::formatErrorMessage(
			Messages::ERROR_MAIN_NO_IR_FILE);
		std::cerr << errorMessage << std::endl;
		return 1;
	} else {
		for (int i = 1; i <argc; i++) {
			filenameBuffer.push_back(argv[i]);
		}
	}

	IRReader reader;
	EscapeDetect ed;
	reader.setIRFileNames(filenameBuffer);
	//std::cout << "Success set IR file name!" << std::endl;
	int success = reader.readIRFiles();
	if (success) {
		ed.setModuleSet(reader.getModuleSet());
		ed.detectEscape();
	}
	return 0;
}
