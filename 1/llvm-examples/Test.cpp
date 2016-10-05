#include "llvm/IRReader/IRReader.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/DebugInfo.h"
#include "llvm/Pass.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Module.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/SourceMgr.h"

using namespace llvm;

Function* getFunctionByName(Module* modules[], std::string name, int length){
	for (int i=0; i<length; i++){
		Function* f = modules[i]->getFunction(name);
		if (f!=nullptr) return f;
	}
	printf("Function %s cannot be found!\n",name.c_str());
	return nullptr;
}

int main(int argc, char **argv){
	// Step (1) Parse the given IR File
	LLVMContext &Context = getGlobalContext();
	SMDiagnostic Err;

	Module* modules[argc-1];

	for (int i=1; i<argc; i++){	

		Module *M = ParseIRFile(argv[1], Err, Context);
		if (M == nullptr){
			fprintf(stderr, "failed to read IR file %s\n", argv[1]);
			return 1;
		}
		modules[i-1] = M;
	}
	
	getFunctionByName(modules,"f",argc-1);
	getFunctionByName(modules,"Alloha!",argc-1);
	
	Module *M = modules[0];

	Function *f = M->getFunction("f");
	if (f==nullptr) printf("f not found\n");
	else printf("f name %s\n", f->getName().str().c_str());



	// Step (2) Traverse all instructions
	for (auto &F: *M)
		// For each function F
		for (auto &BB: F){ // For each basic block BB
			BasicBlock* pre = BB.getSinglePredecessor();
			if (pre!=nullptr){
				printf("Name = %s\n", pre->getName().str().c_str());
			}

			for (auto &I: BB) {// For each instruction I
	
				CallInst *Call = dyn_cast<CallInst>(&I);
				if (Call == nullptr) continue;
				Function *G = Call->getCalledFunction();
				if (G == nullptr) continue;
				printf("Name = %s\n", G->getName().str().c_str());
				
				/*
				BranchInst *Branch = dyn_cast<BranchInst>(&I);
				if (Branch == nullptr) continue;
				printf("%d\n",Branch->isConditional());
				*/
			}
		}
}
