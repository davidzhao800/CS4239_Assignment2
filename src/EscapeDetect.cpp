#include "EscapeDetect.h"

void EscapeDetect::setModule(llvm::Module *aModule) {
	module = aModule;
}

void EscapeDetect::detectEscape() {
	for (auto &F: *module)	// For each function F
	{
		llvm::outs() << "Basic Blocks of " << F.getName() << " in post-order\n";
		
		for (llvm::po_iterator<llvm::BasicBlock *> I = llvm::po_begin(&F.getEntryBlock()),
		IE = llvm::po_end(&F.getEntryBlock()); 
		I != IE; ++I) {
			llvm::outs() << " " << (*I)->getName() << "\n";
		}
	}
}

bool EscapeDetect::isLocalInstruction(llvm::Instruction i) {
	return false;
}


