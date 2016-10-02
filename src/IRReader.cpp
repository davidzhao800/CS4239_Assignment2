#include "IRReader.h"

IRReader::IRReader() {
}

void IRReader::setIRFileNames(std::vector<std::string> aFileNames) {
	fileNames = aFileNames;
}

int IRReader::readIRFiles() {
	//support only single file
	std::string filename = fileNames[0];
	std::string message = Messages::formatMessage
		(Messages::IRREADER_READ_FILE, filename);
	std::cout << message << std::endl;

	module = ParseIRFile(filename, Err, Context);

	if (module == nullptr) {
		std::string errorMessage = Messages::formatErrorMessage
			(Messages::ERROR_IRREADER_FAIL_READ, filename);
		std::cerr << errorMessage << filename << std::endl;
		return 0;
	}
	return 1;
}

llvm::Module *IRReader::getModule() {
	return module;
}

void IRReader::traverseAll() {
	for (auto &F: *module)	// For each function F
	for (auto &BB: F) 	// For each basic block BB
	for (auto &I: BB) 	// For each instruction I
	{
		llvm::CallInst *Call = llvm::dyn_cast<llvm::CallInst>(&I);
		if (Call == nullptr) continue;
		llvm::Function *G = Call->getCalledFunction();
		if (G == nullptr) continue;
		std::cout << "Name = " << G->getName().str().c_str() << std::endl;
	}
}
