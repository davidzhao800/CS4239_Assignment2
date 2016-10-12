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
	typedef DenseMap<Value*, Value*> AliasMap;
	
	VIMap valueToInstruction;
	set<Module*> moduleSet;
	set<Instruction*> errorInstructions;
	StringRef functionName;

	void runDFS(Module * module);
	void recursiveDFSToposort(BasicBlock *BB, 
	AliasMap localAliasMap,  AliasMap globalAliasMap, AliasMap argumentsAliasMap, BBColorMap ColorMap);
	void doBasicBlock(BasicBlock *BB,
	AliasMap *localAliasMap,  AliasMap *globalAliasMap, AliasMap *argumentsAliasMap);

	void handleReturnInst(ReturnInst *returnInst, AliasMap *localAliasMap);
	void handleStoreInst(StoreInst *storeInst, AliasMap *localAliasMap,  AliasMap *globalAliasMap, AliasMap *argumentsAliasMap);
	void handleAllocaInst(AllocaInst *allocaInst, AliasMap *localAliasMap);
	void handleLoadInst(LoadInst *loadInst, AliasMap *localAliasMap,  AliasMap *globalAliasMap, AliasMap *argumentsAliasMap);
	void handleGEPInst(GEPOperator *GEPInst, AliasMap *localAliasMap,  AliasMap *globalAliasMap, AliasMap *argumentsAliasMap);
	
	bool checkGlobalVarEscape(AliasMap *localAliasMap, AliasMap *globalAliasMap, StoreInst *storeInst);
	bool checkArgumentEscape(AliasMap *localAliasMap, AliasMap *argumentsAliasMap, StoreInst *storeInst);
	bool checkLocalVar(AliasMap *localAliasMap, AliasMap *globalAliasMap, AliasMap *argumentsAliasMap, StoreInst *storeInst);
	bool checkGlobalVar(AliasMap *localAliasMap, AliasMap *globalAliasMap, AliasMap *argumentsAliasMap, StoreInst *storeInst);
	bool checkArguments(AliasMap *localAliasMap, AliasMap *globalAliasMap, AliasMap *argumentsAliasMap, StoreInst *storeInst);
	
	bool isReturnBlock(BasicBlock *BB);
	bool isPointerToPointer(const Value* V);
	template<class TypeA>
	bool isInSet(TypeA* aTypeA, set<TypeA*> *aTypeASet) {
		bool result = aTypeASet->find(aTypeA) != aTypeASet->end();
		return result;
	}
	bool isInMap(Value* aValue, AliasMap* aMap);
	void addToMap(AliasMap* aMap, Value* v1, Value* v2);
	void printReport(Instruction* inst, string msg);
public:
	EscapeDetect();
	void setModuleSet(set<Module*> aModuleSet);
	void detectEscape();
};
#endif

