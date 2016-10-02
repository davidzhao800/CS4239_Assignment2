#include "EscapeDetect.h"

void EscapeDetect::setModule(llvm::Module *aModule) {
	module = aModule;
}

void EscapeDetect::detectEscape() {
	for (auto &F: *module)	// For each function F
	for (auto &BB: F) 	// For each basic block BB
	for (auto &I: BB) 	// For each instruction I
	{
		std::cout << I.getOpcode() << std::endl;
	}
}
