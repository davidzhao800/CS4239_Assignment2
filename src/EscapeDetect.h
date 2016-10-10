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
#include "llvm/ADT/DenseMap.h"
#include "Messages.h"
#include <vector>
#include <string>
#include <iostream>
#include <set>

#ifndef ESCAPEDETECT_H
#define ESCAPEDETECT_H
using namespace llvm;
class EscapeDetect {
private:
	enum Color {WHITE, GREY, BLACK};
	typedef DenseMap<const BasicBlock*, Color> BBColorMap;
	typedef DenseMap<Value*, Instruction*> VIMap;
	VIMap valueToInstruction;
	set<Value*> globalVars;
	set<Value*> arguments;
	Module *module;
	
	bool isLocalInstruction(Instruction);
	void doBasicBlock(BasicBlock *BB, set<Value*> *localVar);
	bool isReturnBlock(BasicBlock *BB);
	bool checkGlobalVarEscape(set<Value*> *localVar, StoreInst *storeInst);
	bool checkLocalVar(set<Value*> *localVar, StoreInst *storeInst);
	bool checkGlobalVar(set<Value*> *localVar, StoreInst *storeInst);
	bool isInSet(Value* aValue, set<Value*> *aValueSet);
	void printReport(Instruction* inst, string msg);
public:
	EscapeDetect();
	void setModule(Module *aModule);
	void detectEscape();
	void runDFS();
	void recursiveDFSToposort(BasicBlock *BB, set<Value*> localVar, BBColorMap ColorMap);
};
#endif

