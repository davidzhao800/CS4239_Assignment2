#include "llvm/DebugInfo.h"
#include "llvm/Pass.h"
#include "llvm/PassManager.h"
#include "llvm/Analysis/AliasAnalysis.h"
#include "llvm/Analysis/Passes.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/GlobalVariable.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IRReader/IRReader.h"
#include "llvm/LinkAllPasses.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/ADT/PostOrderIterator.h"
#include "llvm/ADT/ilist.h"
#include "Messages.h"
#include <vector>
#include <string>
#include <iostream>

#ifndef ESCAPEDETECT_H
#define ESCAPEDETECT_H
class EscapeDetect {
private:
	llvm::Module *module;
	bool isLocalInstruction(llvm::Instruction);
public:
	void setModule(llvm::Module *aModule);
	void detectEscape();
};
#endif
