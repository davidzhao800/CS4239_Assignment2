#include "EscapeDetect.h"

EscapeDetect::EscapeDetect() {
	set<Value*> globalVars = set<Value*>();
	set<Value*> arguments = set<Value*>();
	VIMap valueToInstruction = VIMap();
}

void EscapeDetect::setModule(Module *aModule) {
	module = aModule;
}

void EscapeDetect::detectEscape() {
	for (auto &F: *module)	// For each function F
	{
		outs() << "Basic Blocks of " << F.getName() << " in post-order\n";
		po_iterator<BasicBlock *> I = po_begin(&F.getEntryBlock());
		outs() << "-------1-------\n";
		po_iterator<BasicBlock *> IE = po_end(&F.getEntryBlock());
		outs() << "-------2-------\n";
		while (I != IE) {
			//llvm::outs() << " " << (*I)->getName() << "\n";
			++I;
		}
	}
}

bool EscapeDetect::isLocalInstruction(Instruction i) {
	return false;
}

void EscapeDetect::runDFS() {
	outs() << " Running DFS...\n";
	globalVars.clear();
	outs() << " Testing global variables...\n";
	for (Module::global_iterator i = module->global_begin(); i!= module->global_end(); i++){	
		GlobalVariable *g = i;
		if(isa<PointerType>(g->getType())) {
			outs() << g->getName() << " is a pointer\n" ;
			globalVars.insert(g);
		}
	}
	outs() << " Global variables done.\n";
	for (auto &F: *module) {
		if (F.isDeclaration()) {
			//outs() << " This is a function declaration\n";
			continue;
		}
		outs() << "============Processing " << F.getName() << "===========\n";
		arguments.clear();
		outs() << " Testing function arguments...\n";
		for (auto &arg : F.getArgumentList()) {
			if(isa<PointerType>(arg.getType())) {
				outs() << arg.getName() << " is a pointer\n" ;
				arguments.insert(&arg);
			}
		}
		outs() << " Function arguments done.\n";
		set<Value*> localVarSet;
		BBColorMap ColorMap;
		for (Function::const_iterator I = F.begin(), IE = F.end(); I != IE; ++I) {
      		ColorMap[I] = EscapeDetect::WHITE;
    	}
		recursiveDFSToposort(&F.getEntryBlock(), localVarSet, ColorMap);
	}
}

void EscapeDetect::recursiveDFSToposort(BasicBlock *BB, set<Value*> localVar, BBColorMap ColorMap) {
	if (!isReturnBlock(BB)) {
		ColorMap[BB] = EscapeDetect::GREY;
	}
	doBasicBlock(BB, &localVar);
	TerminatorInst *TInst = BB->getTerminator();
	for (unsigned I = 0, NSucc = TInst->getNumSuccessors(); I < NSucc; ++I) {
      BasicBlock *Succ = TInst->getSuccessor(I);
      Color SuccColor = ColorMap[Succ];
      if (SuccColor == EscapeDetect::WHITE ||
			(SuccColor == EscapeDetect::GREY && NSucc == 1)) {
        recursiveDFSToposort(Succ, localVar, ColorMap);
      }
    }
    // This BB is finished (fully explored)
    if (!isReturnBlock(BB)) {
		ColorMap[BB] = EscapeDetect::BLACK;
	}
}

void EscapeDetect::doBasicBlock(BasicBlock *BB, set<Value*> *localVar) {
	for (auto &I : *BB) {
		outs() << "--------Do Instruction " << &I << "---------\n";
		if (isa<ReturnInst>(I)) {
			outs() << "Hit return instruction!\n";
			ReturnInst *returnInst = dyn_cast<ReturnInst>(&I);
			Value *returnValue = returnInst->getReturnValue();
			if (returnValue == nullptr) {
				outs() << "The return value is void\n";	
				continue;
			} else if (!isa<PointerType>(returnValue->getType())) {
				outs() << "The return value is not a pointer\n";
				continue;
			}
			returnValue = returnInst->getPrevNode()->getOperand(0);
			outs() << "-Return value is: " << returnValue << "\n";
			
			if (isInSet(returnValue, localVar)) {
				printReport(&I, "Escapes from return value.");			
			}
		} else if (isa<StoreInst>(I)) {
			StoreInst *storeInst = dyn_cast<StoreInst>(&I);
			if (!checkGlobalVarEscape(localVar, storeInst)) {
				if (!checkGlobalVar(localVar, storeInst)) {
					checkLocalVar(localVar, storeInst);
				}
			}
		} else if (isa<AllocaInst>(I)) {
			AllocaInst *allocaInst = dyn_cast<AllocaInst>(&I);
			Type *allocaType = allocaInst->getAllocatedType();
			if (isa<ArrayType>(*allocaType) || isa<IntegerType>(*allocaType)) {
				Value *value = dyn_cast<Value>(allocaInst);
				outs() << allocaInst->getName() << " is a local variable\n";
				localVar->insert(allocaInst);
			}
		}
	}
}

bool EscapeDetect::isReturnBlock(BasicBlock *BB) {
	TerminatorInst *TInst = BB->getTerminator();
	if (isa<ReturnInst>(TInst)) {
		return true;
	} else {
		return false;
	}
}

bool EscapeDetect::checkGlobalVarEscape(set<Value*> *localVar, StoreInst *storeInst) {
	outs() << "check global escape: " << storeInst << "\n";
	Value *src = storeInst->getOperand(0);
	Value *dst = storeInst->getOperand(1);
	if (isInSet(dst, &globalVars) &&
		isInSet(src, localVar)) {
		printReport(storeInst, "Escapes from global varibale.");
		return true;
	} else {
		return false;
	}
}

bool EscapeDetect::checkLocalVar(set<Value*> *localVar, StoreInst *storeInst) {
	Value *src = storeInst->getOperand(0);
	Value *dst = storeInst->getOperand(1);
	outs() << "check store local var: " << storeInst << "\n";
	//check whether store constants
	if (isa<Constant>(*src)) {
		if (!isInSet(dst, localVar)) {
			outs() << dst->getName() << " is a local variable\n";
			localVar->insert(dst);
		}
		outs() << "1\n";
		return true;
	}
	//check whether assign local vars
	Instruction *previousInst = storeInst->getPrevNode();
	if (isa<LoadInst>(*previousInst) || isa<GetElementPtrInst>(*previousInst)) {
		src = previousInst->getOperand(0);
	}
	
	if (isInSet(src, localVar)) {
		if (!isInSet(dst, localVar)) {
			outs() << dst->getName() << " is a local variable\n";
			localVar->insert(dst);
		}
		outs() << "2\n";
		return true;
	}
	outs() << storeInst << ": not a local store instruction\n";
	return false;
}

bool EscapeDetect::checkGlobalVar(set<Value*> *localVar, StoreInst *storeInst) {
	GEPOperator *gep = dyn_cast<GEPOperator>(storeInst);
	Value *src = storeInst->getOperand(0);
	Value *dst = storeInst->getOperand(1);
	outs() << "check store global var: " << storeInst << "\n";
	Instruction *previousInst = storeInst->getPrevNode();
	if (isa<ConstantExpr>(*src)) {
		ConstantExpr *expr = dyn_cast<ConstantExpr>(src);
		if (expr->getOpcode() == Instruction::GetElementPtr) {
			outs() << "hahhaah the src is a getelementptr\n";
			GetElementPtrInst *getElePtrInst = dyn_cast<GetElementPtrInst>(src);
			src = getElePtrInst->getOperand(0);
			outs() << "src changed\n";
		}
	}
	if (isInSet(src, &globalVars)) {
		outs() << "The local varibale is assigned with a global variable.\n";
		if (isInSet(dst, localVar)) {	
			localVar->erase(localVar->find(dst));
		}
		if (!isInSet(dst, &globalVars)) {
			globalVars.insert(dst);
		}
		return true;
	} else {
		outs() << storeInst << ": not a global store instruction\n";
		return false;
	}
}

bool EscapeDetect::isInSet(Value* aValue, set<Value*> *aValueSet) {
	bool result = aValueSet->find(aValue) != aValueSet->end();
	return result;
}

void EscapeDetect::printReport(Instruction* inst, string message) {
	errs() << "WARNING: ";
    if (MDNode *n = inst->getMetadata("dbg")) {
		DILocation loc(n);
        unsigned line = loc.getLineNumber();
        StringRef file = loc.getFilename();
        StringRef dir = loc.getDirectory();
        errs() << "Line " << line << " of file " << file.str()
         << " in " << dir.str() << ": ";
    }
    errs() << message << "\n";
}
