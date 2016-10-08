#include "EscapeDetect.h"

void EscapeDetect::setModule(llvm::Module *aModule) {
	module = aModule;
}

void EscapeDetect::detectEscape() {
	for (auto &F: *module)	// For each function F
	for (auto &BB: F) 	// For each basic block BB
	for (auto &I: BB) 	// For each instruction I
	{
		std::cout << I.getOpcode() << ": ";
		unsigned num = I.getNumOperands();
		
		for (unsigned i = 0; i < num; i++) {
			std::cout << I.getOperand(i)->getName().str().c_str() << " ";
		}
		std::cout << std::endl;
	}
}

bool EscapeDetect::isLocalInstruction(llvm::Instruction i) {
	
}
