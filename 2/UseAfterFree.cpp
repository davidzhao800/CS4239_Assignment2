//===------ BadCast.cpp - C Secure Coding Standard Violation Detector -----===//
//
//                     Security Analysis
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// According to Rule EXP36-C of SEI CERT C Coding Standard at
// https://www.securecoding.cert.org/confluence/display/c/SEI+CERT+C+Coding+Standard
// Do not cast pointers into more strictly aligned pointer types.
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
bool check_escape( BasicBlock* bb, StringRef returnName, set<StringRef> localValue);

int main(int argc, char **argv) {
	LLVMContext &Context = getGlobalContext();
	SMDiagnostic Err;
	Module *M = ParseIRFile(argv[1], Err, Context);
	if (M == nullptr) {
		fprintf(stderr, "failed to read IR file %s\n", argv[1]);
		return 1;
	}

	for (auto &F : *M) { // For each function F
		Type* r = F.getReturnType();

		if (r->isPointerTy()) {
			printf("Basic Block Size: %d\n", F.getBasicBlockList().size());


			set<StringRef> localVar;
			set<StringRef> localPointer;
			Value *returnValue;
			StringRef retPointerName;
			BasicBlock *lastBB;

			for (auto &bb : F) {
				// get return pointer name
				for (auto &i : bb) {
					if (i.getOpcode() == Instruction::Ret) {
						ReturnInst *retInstr = dyn_cast<ReturnInst>(&i);
						returnValue = retInstr->getPrevNode()->getOperand(0);
						if(returnValue->hasName()){
							retPointerName = returnValue->getName();
						}

						printf("Return pointer is %s\n", retPointerName);
						lastBB = &bb;
					}
				}

				//get local variable
				for (auto &i : bb) {
					if (i.getOpcode() == Instruction::Alloca) {

						AllocaInst *allocaInstr = dyn_cast<AllocaInst>(&i);
						printf("%s\n", allocaInstr->getName());
						PointerType *allocType = allocaInstr->getType();
						IntegerType *allocElemType = dyn_cast<IntegerType>(allocType->getElementType());
						if ( allocElemType->isPointerTy() ) {

							localPointer.insert(allocaInstr->getName());
						} else {
							localVar.insert(allocaInstr->getName());
						}

					}

				}
			}
			cout << "Size of localPointer: " << localPointer.size() << endl;
			cout << "Size of localVar: "  << localVar.size() << endl;

			bool result = check_escape( lastBB, retPointerName, localVar);
			cout << "This function does not escape? "  << result << endl;
		}

	}
	return 0;
}

bool check_escape( BasicBlock* bb, StringRef returnName, set<StringRef> localValue) {

	for (BasicBlock::iterator i = bb->end(), e = bb->begin(); i != e; --i){
		if (i->getOpcode() == Instruction::Store) {
			StoreInst *storeInstr = dyn_cast<StoreInst>(i);
			StringRef op2 = storeInstr->getOperand(1)->getName();
			StringRef op1 = storeInstr->getOperand(0)->getName();

			if (op2 == returnName) {
				if (localValue.find(op1) != localValue.end()) {
					printf("Return pointer points to local var %s\n", op1);
					return false;
				} else {
					if (i->getPrevNode()->getOpcode() == Instruction::GetElementPtr) {
						GetElementPtrInst *getElementPtrInstr = dyn_cast<GetElementPtrInst>(i->getPrevNode());

						// array name
						StringRef op = getElementPtrInstr->getOperand(0)->getName();

						printf("Return pointer points to non-local array %s\n", op);
						return false;
					}
					printf("Return pointer points to non-local var %s\n", op1);
					return true;
				}
			}
		}
	}

	for (pred_iterator PI = pred_begin(bb), E = pred_end(bb); PI != E;
			++PI) {
		BasicBlock *Pred = *PI;
		return check_escape( Pred, returnName, localValue);
	}
	return true;
}
