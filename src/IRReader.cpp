#include "IRReader.h"

IRReader::IRReader() {
	set<Module*> moduleSet = set<Module*>();
}

void IRReader::setIRFileNames(std::vector<std::string> aFileNames) {
	fileNames = aFileNames;
}

int IRReader::readIRFiles() {
	for (auto& filename : fileNames) {
		string message = Messages::formatMessage
			(Messages::IRREADER_READ_FILE, filename);
		cout << message << endl;
		Module *module = ParseIRFile(filename, Err, Context);
		if (module == nullptr) {
			string errorMessage = Messages::formatErrorMessage
				(Messages::ERROR_IRREADER_FAIL_READ, filename);
			cerr << errorMessage << filename << endl;
		} else {
			moduleSet.insert(module);
		}
	}
	return 1;
}

set<Module*> IRReader::getModuleSet() {
	return moduleSet;
}
