//===------ UseAfterFree.cpp - C Secure Coding Standard Violation Detector -----===//
//
//                     Security Analysis
//
//
//===----------------------------------------------------------------------===//
//
// According to Rule DCL30-C of SEI CERT C Coding Standard at
// https://www.securecoding.cert.org/confluence/display/c/SEI+CERT+C+Coding+Standard
// Declare objects with appropriate storage durations
//
// This analysis detects such violations.
//
//===----------------------------------------------------------------------===//

#define DEBUG_TYPE "use-after-free"
#include "llvm/DebugInfo.h"
#include "llvm/Pass.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IRReader/IRReader.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Analysis/CFG.h"
#include <string>
#include <map>
#include <iostream>
#include <set>

using namespace std;
using namespace llvm;
bool check_escape( BasicBlock* bb, StringRef returnName, set<StringRef> localValue, set<pair<BasicBlock*,BasicBlock*>> *edges);
void getReturn(BasicBlock* bb, Value* returnValue, set<pair<BasicBlock*,BasicBlock*>>* edges, set<pair<BasicBlock*, StringRef>>* mutipleReturn);
bool check_arg_ptr(BasicBlock* firstBB, BasicBlock* bb, StringRef argName, set<StringRef> localValue, set<pair<BasicBlock*,BasicBlock*>> * edges);
bool _check_arg_ptr( Value* intermediate, BasicBlock* bb, StringRef argName, set<StringRef> localValue, set<pair<BasicBlock*,BasicBlock*>> * edges);
StringRef functionName;

int main(int argc, char **argv) {
	LLVMContext &Context = getGlobalContext();
	SMDiagnostic Err;
	Module* modules[argc - 1];

	for (int i = 1; i < argc; i++) {

		Module *M = ParseIRFile(argv[i], Err, Context);

		if (M == nullptr) {
			fprintf(stderr, "failed to read IR file %s\n", argv[1]);
			return 1;
		}
		modules[i - 1] = M;
	}

	for (int o = 0; o < argc - 1; o++) {
		Module* m = modules[o];
		set<StringRef> globalPointers;
		for ( Module::global_iterator i = m->global_begin(); i!= m->global_end(); i++){
			GlobalVariable *g = i;

			IntegerType *globalVarType = dyn_cast<IntegerType>(g->getType()->getPointerElementType());

			if( globalVarType->isPointerTy() ) {
				globalPointers.insert(g->getName());
			}
		}

		for (auto &F : *m) { // For each function F

			Type* r = F.getReturnType();
			functionName = F.getName();
			set<StringRef> localVar;
			set<StringRef> localPointer;
			Value *returnValue;
			StringRef retPointerName;
			BasicBlock *lastBB;
			BasicBlock *firstBB;
			set<pair<BasicBlock*, BasicBlock*>> edges;
			set<pair<BasicBlock*, StringRef>> mutipleReturn;
			set<pair<BasicBlock*, StringRef>> bonus;

			for (auto &bb : F) {

				// get return pointer name
				for (auto &i : bb) {
					if (i.getOpcode() == Instruction::Ret) {
						ReturnInst *retInstr = dyn_cast<ReturnInst>(&i);
						lastBB = &bb;
						if (r->isPointerTy()) {
//							Value * retValue = retInstr->getOperand(0);
//							uintptr_t returnValue = reinterpret_cast<uintptr_t>(retValue);
							returnValue = retInstr->getPrevNode()->getOperand(0);
							if (returnValue->hasName()) {
								retPointerName = returnValue->getName();

								//printf("Return pointer is %s\n",retPointerName);

								pair<BasicBlock*, StringRef> onlyReturn(lastBB,
										retPointerName);

								mutipleReturn.insert(onlyReturn);

							} else {

								//printf("Return value pointer is %p\n", returnValue);

								getReturn(lastBB, returnValue, &edges,
										&mutipleReturn);
								//							cout << "size of returns " << mutipleReturn.size()
								//									<< endl;
								//							for (auto &x : mutipleReturn) {
								//								printf("%s\n", x.second);
								//								printf("%p\n", x.first);
								//							}

							}
						}

					}

				}

				//get local variable
				for (auto &i : bb) {
					if (i.getOpcode() == Instruction::Alloca) {
						firstBB = &bb;
						AllocaInst *allocaInstr = dyn_cast<AllocaInst>(&i);
						//printf("%s\n", allocaInstr->getName());
						PointerType *allocType = allocaInstr->getType();
						IntegerType *allocElemType = dyn_cast<IntegerType>(
								allocType->getElementType());
						if (allocElemType->isPointerTy()) {

							localPointer.insert(allocaInstr->getName());
						} else {
							localVar.insert(allocaInstr->getName());
						}

					}

				}

			}
			//cout << localVar.size() << endl;
			for (auto &x : localVar ) {
				if(x.empty()){
					localVar.erase(localVar.find(x));
				}
			}
			//cout << localVar.size() << endl;

			// get funtion argument
			for(Function::arg_iterator k = F.arg_begin(); k != F.arg_end(); k++){
				Argument *a = k;
				if (a->getType()->isPointerTy() && a->getType()->getContainedType(0)->isPointerTy()){

					pair<BasicBlock*, StringRef> argPointer(lastBB, a->getName());
					bonus.insert(argPointer);
				}
			}

			for (StringRef x : globalPointers) {

				//printf("%s    %p\n", x, lastBB);
				pair<BasicBlock*, StringRef> globalVar(lastBB, x);
				mutipleReturn.insert(globalVar);
			}

			for (auto &x : mutipleReturn) {
				set<pair<BasicBlock*, BasicBlock*>> checkEdges;

				//printf("%s    %p\n",x.second, x.first);
				bool result = check_escape(x.first, x.second, localVar,
						&checkEdges);
				//cout << "This function escapes? " << result << endl;
			}

			for (auto &x : bonus) {
				set<pair<BasicBlock*, BasicBlock*>> checkEdges;

				//printf("%s    %p\n",x.second, x.first);
				bool result = check_arg_ptr(firstBB, x.first, x.second, localVar,
						&checkEdges);
				//cout << "This function escapes? " << result << endl;
			}
		}
	}
	return 0;
}

void getReturn(BasicBlock* bb, Value* returnValue, set<pair<BasicBlock*,BasicBlock*>>* edges, set<pair<BasicBlock*, StringRef>>* mutipleReturn) {
	//int count=0;
	BasicBlock::iterator i = bb->end();
	BasicBlock::iterator e = bb->begin();
	e--;
	i--;
	for (; i != e; --i){
		//cout << i->getOpcode() << endl;
		//count++;
		if (i->getOpcode() == Instruction::Store) {

			StoreInst *storeInstr = dyn_cast<StoreInst>(i);
			Value* op2 = storeInstr->getOperand(1);
			Value* op1 = storeInstr->getOperand(0);
			StringRef returnPointerName;

			if (op2 == returnValue && i->getPrevNode()->getOpcode() == Instruction::Load) {
				returnPointerName = i->getPrevNode()->getOperand(0)->getName();
				pair<BasicBlock*,StringRef> newReturn (bb,returnPointerName);
				mutipleReturn->insert(newReturn);
			}
		}
	}
	for (pred_iterator PI = pred_begin(bb), E = pred_end(bb); PI != E; ++PI) {

		BasicBlock *Pred = *PI;
		pair<BasicBlock*, BasicBlock*> newEdge(Pred, bb);

		if (edges->find(newEdge) == edges->end()) {

			edges->insert(newEdge);

			getReturn(Pred, returnValue, edges, mutipleReturn);
		}

	}
}

bool check_escape( BasicBlock* bb, StringRef returnName, set<StringRef> localValue,
		set<pair<BasicBlock*,BasicBlock*>> * edges) {

	int count=0;
	BasicBlock::iterator i = bb->end();
	BasicBlock::iterator e = bb->begin();
	e--;
	i--;
	for (; i != e; --i){

		count++;
		if (i->getOpcode() == Instruction::Store) {

			StoreInst *storeInstr = dyn_cast<StoreInst>(i);
			StringRef op1 = storeInstr->getOperand(0)->getName();
			StringRef op2 = storeInstr->getOperand(1)->getName();

			if (op2 == returnName) {

				if (localValue.find(op1) != localValue.end()) {
					//printf("Return pointer points to local var %s\n", op1);

					errs() << "WARNING: ";
					if (MDNode *n = i->getMetadata("dbg")) { // Here I is an LLVM instruction

						DILocation loc(n); // DILocation is in DebugInfo.h
						unsigned line = loc.getLineNumber();
						StringRef file = loc.getFilename();
						StringRef dir = loc.getDirectory();
						errs() << "Line " << line << " of file " << file.str()
								<< " in " << functionName << " in " << dir.str() << ": ";
					}
					errs() << "Stack-local variable \'"<< op1 <<"\' escape!\n";

					return true;
				} else {
					if (count < bb->getInstList().size() && i->getPrevNode()->getOpcode() == Instruction::GetElementPtr) {
						GetElementPtrInst *getElementPtrInstr = dyn_cast<GetElementPtrInst>(i->getPrevNode());

						// array name
						StringRef op = getElementPtrInstr->getOperand(0)->getName();

						if (localValue.find(op) != localValue.end()) {
							//printf("Return pointer points to local array %s\n", op);
							errs() << "WARNING: ";
							if (MDNode *n = i->getMetadata("dbg")) { // Here I is an LLVM instruction

								DILocation loc(n); // DILocation is in DebugInfo.h
								unsigned line = loc.getLineNumber();
								StringRef file = loc.getFilename();
								StringRef dir = loc.getDirectory();
								errs() << "Line " << line << " of file "
										<< file.str() << " in " << functionName <<" in "<< dir.str()
										<< ": ";
							}
							errs() << "Stack-local array \'"<< op << "\' escape!\n";
							return true;
						}

						//printf("Return pointer points to non-local array %s\n", op);

					} else if (count < bb->getInstList().size() && i->getPrevNode()->getOpcode() == Instruction::Load){
						LoadInst *loadInstr = dyn_cast<LoadInst>(i->getPrevNode());
						if (loadInstr->getOperand(0)->hasName()){

							return check_escape(bb, loadInstr->getOperand(0)->getName(), localValue, edges);
						}
					}

					//printf("Return pointer points to non-local var %s\n", op1);
					return false;
				}
			}
		}
	}

	bool result = false;

	for (pred_iterator PI = pred_begin(bb), E = pred_end(bb); PI != E;
			++PI) {
		//printf("%p is getting its predecor\n",bb);
		BasicBlock *Pred = *PI;
		pair<BasicBlock*,BasicBlock*> newEdge (Pred, bb);

		if (edges->find(newEdge) == edges->end()) {
			//printf("%p -> %p\n", Pred, bb);
			edges->insert(newEdge);
			//cout << "Number of edges: " << edges->size() << endl;
			result = result || check_escape(Pred, returnName, localValue, edges);
		}

	}
	return result;
}

bool check_arg_ptr(BasicBlock* firstBB, BasicBlock* bb, StringRef argName, set<StringRef> localValue, set<pair<BasicBlock*,BasicBlock*>> * edges){

	Value *intermediate;
	for (auto &i : *firstBB){
		if (i.getOpcode() == Instruction::Store) {

			StoreInst *storeInstr = dyn_cast<StoreInst>(&i);
			StringRef op1 = storeInstr->getOperand(0)->getName();
			StringRef op2 = storeInstr->getOperand(1)->getName();

			if (op1 == argName) {
				//cout << "found store **%argptr ***%1!" << endl;
				//get %1
				intermediate = storeInstr->getOperand(1);
			}
		}
	}
	return _check_arg_ptr(intermediate, bb, argName, localValue, edges);
}

bool _check_arg_ptr( Value* intermediate, BasicBlock* bb, StringRef argName, set<StringRef> localValue, set<pair<BasicBlock*,BasicBlock*>> * edges) {
	//printf("current executing block is %p\n", bb);
	//cout << "number of instructions: " << bb->getInstList().size() << endl;

	int count=0;
	BasicBlock::iterator i = bb->end();
	BasicBlock::iterator e = bb->begin();
	e--;
	i--;
	for (; i != e; --i){
		//cout << i->getOpcode() << endl;
		count++;
		if (i->getOpcode() == Instruction::Load) {

			LoadInst *loadInstr = dyn_cast<LoadInst>(i);
			Value *op1 = loadInstr->getOperand(0);

			if (op1 == intermediate){
				if(i->getNextNode()->getOpcode() == Instruction::Store){
					StoreInst *storeInstr = dyn_cast<StoreInst>(i->getNextNode());
					StringRef opName2 = storeInstr->getOperand(1)->getName();
					StringRef opName1 = storeInstr->getOperand(0)->getName();

					if (localValue.find(opName1) != localValue.end()) {
						//printf("Return pointer points to local var %s\n", op1);

						errs() << "WARNING: ";
						if (MDNode *n = i->getMetadata("dbg")) { // Here I is an LLVM instruction

							DILocation loc(n); // DILocation is in DebugInfo.h
							unsigned line = loc.getLineNumber();
							StringRef file = loc.getFilename();
							StringRef dir = loc.getDirectory();
							errs() << "Line " << line << " of file "
									<< file.str() << " in " << functionName
									<< " in " << dir.str() << ": ";
						}
						errs() << "Stack-local variable \'" << opName1
								<< "\' escape!\n";

						return true;
					} else {
						if (count < bb->getInstList().size()
								&& i->getPrevNode()->getOpcode() == Instruction::GetElementPtr) {
							GetElementPtrInst *getElementPtrInstr = dyn_cast<GetElementPtrInst>(i->getPrevNode());

							// array name
							StringRef op = getElementPtrInstr->getOperand(0)->getName();

							if (localValue.find(op) != localValue.end()) {
								//printf("Return pointer points to local array %s\n", op);
								errs() << "WARNING: ";
								if (MDNode *n = i->getMetadata("dbg")) { // Here I is an LLVM instruction

									DILocation loc(n); // DILocation is in DebugInfo.h
									unsigned line = loc.getLineNumber();
									StringRef file = loc.getFilename();
									StringRef dir = loc.getDirectory();
									errs() << "Line " << line << " of file "
											<< file.str() << " in "
											<< functionName << " in "
											<< dir.str() << ": ";
								}
								errs() << "Stack-local array \'" << op
										<< "\' escape!\n";
								return true;
							}

							//printf("Return pointer points to non-local array %s\n", op);

						}
						//printf("Return pointer points to non-local var %s\n", op1);
						return false;
					}
				}
			}
		}
	}

	bool result = false;

	for (pred_iterator PI = pred_begin(bb), E = pred_end(bb); PI != E;
			++PI) {
		//printf("%p is getting its predecor\n",bb);
		BasicBlock *Pred = *PI;
		pair<BasicBlock*,BasicBlock*> newEdge (Pred, bb);

		if (edges->find(newEdge) == edges->end()) {
			//printf("%p -> %p\n", Pred, bb);
			edges->insert(newEdge);
			//cout << "Number of edges: " << edges->size() << endl;
			result = result || _check_arg_ptr(intermediate, Pred, argName, localValue, edges);
		}

	}
	return result;
}
