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

std::set<std::string> traceback(LoadInst *L){	

	std::set<std::pair<BasicBlock*,BasicBlock*>> history;
	printf("Operand 0 = %s\n", L->getOperand(0)->getName().str().c_str());
	std::string str = L->getOperand(0)->getName().str();
	std::set<Instruction*> pending;
	std::set<std::string> result;

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
				result.insert(S->getOperand(0)->getName().str());				
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

	return result;
}

Function* getFunctionByName(Module* modules[], std::string name, int length){
	for (int i=0; i<length; i++){
		Function* f = modules[i]->getFunction(name);
		if (f!=nullptr && !f->empty()) return f;
	}
	printf("Function %s cannot be found!\n",name.c_str());
	return nullptr;
}

void checkUnusedFunction(Module* modules[], int length, std::set<Function*> *checked){
	printf("\n------Unused Function Result------\n");		
	bool empty = true;		
	for (int i = 0; i < length; i++){
		Module* m = modules[i];
		for (auto &f: *m){
			if (f.empty()) continue;
			if (checked->find(&f) == checked->end()){
				empty = false;
				printf("Unused function %s found in Module %s\n"
						,f.getName().str().c_str(), arg_v[i+1]);
			}
		}
	}
	if (empty){
		printf("No Unused Function Found!\n");		
	}
}

void processFunction(Module* modules[], std::set<Function*> *pending, std::set<Function*> *checked){

	Function* f = *(pending->begin());
	printf ("processing function %s\n", f->getName().str().c_str());	

	if (f->empty()){
		checked->insert(f);
		pending->erase(f);
		printf("%s is a prototype\n", f->getName().str().c_str());
		f = getFunctionByName(modules, f->getName().str(), arg_c-1);
	}

	//f == nullptr when it is a system call (eg printf)
	if (f!=nullptr){
		for (auto &BB: *f){ // For each basic block BB
			Instruction* prev = nullptr;
			for (auto &I: BB) {// For each instruction I
				CallInst *Call = dyn_cast<CallInst>(&I);

				if (Call != nullptr){
					Function *G = Call->getCalledFunction();
					if (G == nullptr && prev!=nullptr) {

						LoadInst *L = dyn_cast<LoadInst>(prev);
						if (L != nullptr){
							printf("Operand 0 = %s\n", L->getOperand(0)->getName().str().c_str());
							std::set<std::string> res = traceback(L);
							for (std::set<std::string>::iterator it = res.begin(); it!=res.end();it++){

								Function* curr = getFunctionByName(modules,*it,arg_c-1);
								if (curr!=nullptr){
									bool shouldAdd = true;
									if (checked->find(curr) != checked->end()){
										printf("funciton %s found in checked!\n", (curr)->getName().str().c_str());
										shouldAdd = false;									
									}
									if (pending->find(curr) != pending->end()){
										printf("funciton %s found in pending!\n", (curr)->getName().str().c_str());
										shouldAdd = false;									
									}
									if (shouldAdd){
										printf("inserting %s into pending!\n", curr->getName().str().c_str());
										pending->insert(curr);
									}	
								}
							}
						}

					}	
					else if (G != nullptr){
						bool shouldAdd = true;						
						if (checked->find(G) != checked->end()){
							printf("funciton %s found in checked!\n", G->getName().str().c_str());
							shouldAdd = false;
						}

						if (pending->find(G) != pending->end()){
							printf("funciton %s found in pending!\n", G->getName().str().c_str());
							shouldAdd = false;
						}
						if (shouldAdd){
							printf("inserting %s into pending!\n", G->getName().str().c_str());
							pending->insert(G);
						}		
					}
				}
				prev = &I;
			}
			prev = nullptr;
		}


		checked->insert(f);
		pending->erase(f);
	}
}

void printFunctionSet(std::set<Function*> *func_set){
	printf("------------------printing function set-----------------\n");
	for (std::set<Function*>::iterator it=func_set->begin(); it!=func_set->end();it++){
		if (*it==nullptr) {
			printf("%s\n","NULL");
			continue;
		}
		printf("%s\n", (*it) -> getName().str().c_str());
	}
}

int main(int argc, char **argv){
	// Step (1) Parse the given IR File
	LLVMContext &Context = getGlobalContext();
	SMDiagnostic Err;

	std::set<Function*> pending;
	std::set<Function*> checked;

	Module* modules[argc-1];

	for (int i=1; i<argc; i++){	

		Module *M = ParseIRFile(argv[i], Err, Context);

		if (M == nullptr){
			fprintf(stderr, "failed to read IR file %s\n", argv[1]);
			return 1;
		}
		modules[i-1] = M;
	}

	arg_v = argv;
	arg_c = argc;

	Function* mainFunction = getFunctionByName(modules,"main",argc-1);
	if (mainFunction == nullptr){
		printf("Since main function is not found, all functions are dead\n");
		printf("Program exiting\n");		
		return 0;
	}

	pending.insert(mainFunction);

	while (pending.size()!=0){
		processFunction(modules, &pending, &checked);
	}

	printFunctionSet(&checked);	

	printf("\n");
	checkUnusedFunction(modules, argc-1, &checked);

	/*	
			getFunctionByName(modules,"f",argc-1);
			getFunctionByName(modules,"Alloha!",argc-1);

			Module *M = modules[0];

			Function *f = M->getFunction("f");
			if (f==nullptr) printf("f not found\n");
			else printf("f name %s\n", f->getName().str().c_str());

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


		BranchInst *Branch = dyn_cast<BranchInst>(&I);
		if (Branch == nullptr) continue;
		printf("%d\n",Branch->isConditional());

		}
		}
	 */
}
