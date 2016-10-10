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
#include "Messages.h"
#include <vector>
#include <set>
#include <string>
#include <iostream>

#ifndef IRReader_H
#define IRReader_H
using namespace llvm;
class IRReader {
private:
	LLVMContext &Context = getGlobalContext();
	SMDiagnostic Err;
	vector<string> fileNames;
	set<Module*> moduleSet;
public:
	IRReader();
	void setIRFileNames(vector<string> aFileNames);
	int readIRFiles();
	set<Module*> getModuleSet();
};
#endif
