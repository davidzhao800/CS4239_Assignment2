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
#include "llvm/Analysis/CFG.h"
#include <set>

using namespace llvm;

char** arg_v;
int arg_c;
void traceback(LoadInst *L){
	//printf("traceback: 1    %d\n", L==nullptr);
	//printf("traceback: 2    %d\n", L->getPrevNode()->getOperand(0)->getName());
	//printf("traceback: 3    %s\n", L->getPrevNode()->getOperand(0)->getName().str().c_str());	

	

	std::set<std::pair<BasicBlock*,BasicBlock*>> history;
	printf("Operand 0 = %s\n", L->getOperand(0)->getName().str().c_str());
	std::string str = L->getOperand(0)->getName().str();
	std::set<Instruction*> pending;

	pending.insert(L);

	while (!pending.empty()){
		//first instruction in a block
		Instruction* I = *pending.begin();
		pending.erase(I);

		StoreInst *S = dyn_cast<StoreInst>(I);

		if (S != nullptr){
			if (S->getOperand(1)->getName().str() == str){
				printf("found store inst %p:",S);
				printf("Store Operand 0 = %s\n", S->getOperand(0)->getName().str().c_str());
				continue;
			}
		}

		//if (I->getPrevNode() == nullptr){
		if (I==I->getParent()->begin()){
			BasicBlock *B = I->getParent();
			for (pred_iterator it = pred_begin(B);
					it != pred_end(B); it++){
				std::pair<BasicBlock*,BasicBlock*> edge(B,*it);
				if (history.find(edge) == history.end()){
					history.insert(edge);
					Instruction* last = (*it)->end()--;
					if (last!=nullptr){
						pending.insert(last);
					}
				}
			}
		}

		else{
			pending.insert(I->getPrevNode());
		}
	}
}


int main(int argc, char **argv){
	// Step (1) Parse the given IR File
	LLVMContext &Context = getGlobalContext();
	SMDiagnostic Err;

	arg_v = argv;
	arg_c = argc;

	Module *M = ParseIRFile(argv[1], Err, Context);
	int i = 0;	

	for (auto &F: *M){
		// For each function F
		for (auto &BB: F){ // For each basic block BB
			//printf("inside BB\n");
			Instruction* prev = nullptr;
			for (auto &I: BB) {// For each instruction I
				//printf("inside I\n");				

				CallInst *Call = dyn_cast<CallInst>(&I);
				if (Call != nullptr){

					printf("%d\n",Call->getNumOperands());

					Function *G = Call->getCalledFunction();								
					if (G == nullptr) {

						if (prev!=nullptr){
							LoadInst *L = dyn_cast<LoadInst>(prev);
							if (L != nullptr){
								printf("Operand 0 = %s\n", L->getOperand(0)->getName().str().c_str());
								traceback(L);
							}
						}

					}else{
						printf("Name = %s\n", G->getName().str().c_str());
					}
				}

				/*
				   StoreInst *S = dyn_cast<StoreInst>(&I);
				   if (S != nullptr){
				   printf("Store Operand 0 = %s\n", S->getOperand(0)->getName().str().c_str());
				   printf("Store Operand 1 = %s\n", S->getOperand(1)->getName().str().c_str());
				   }*/
				prev = &I;
			}
			prev = nullptr;
		}
	}
}
