#include "EscapeDetect.h"

EscapeDetect::EscapeDetect() {
	VIMap valueToInstruction = VIMap();
	set<Instruction*> errorInstructions = set<Instruction*>();
}

void EscapeDetect::setModuleSet(set<Module*> aModuleSet) {
	moduleSet = aModuleSet;
}

void EscapeDetect::detectEscape() {
	outs() << "Detecting Escapes...\n";
	for (auto& module : moduleSet) {
		runDFS(module);	
	}
}

void EscapeDetect::runDFS(Module * module) {
	//outs() << " Running DFS...\n";
	//outs() << " Testing global variables...\n";
	outs() << "============Processing " << module->getModuleIdentifier() << "===========\n";
	set<Value*> globalVars;
	for (Module::global_iterator i = module->global_begin(); i!= module->global_end(); i++)	{	
		GlobalVariable *g = i;
		if(isa<PointerType>(g->getType())) {
			//outs() << g->getName() << " is a pointer\n" ;
			globalVars.insert(g);
		}
	}
	//outs() << " Global variables done.\n";
	for (auto &F: *module) {
		if (F.isDeclaration()) {
			//outs() << " This is a function declaration\n";
			continue;
		}
		outs() << "Processing " << F.getName() << "...\n";
		functionName = F.getName();
		set<Value*> arguments;
		//outs() << " Testing function arguments...\n";
		for (auto &arg : F.getArgumentList()) {
			if(isPointerToPointer(&arg)) {
				
				//outs() << arg.getName() << " is a pointer to pointer\n" ;
				arguments.insert(&arg);
			}
		}
		//outs() << " Function arguments done.\n";
		set<Value*> localVarSet;
		BBColorMap ColorMap;
		for (Function::const_iterator I = F.begin(), IE = F.end(); I != IE; ++I) {
      		ColorMap[I] = EscapeDetect::WHITE;
    	}
		recursiveDFSToposort(&F.getEntryBlock(), localVarSet, globalVars, arguments, ColorMap);
		outs() << F.getName() << " done.\n";
	}
}

void EscapeDetect::recursiveDFSToposort(BasicBlock *BB, 
	set<Value*> localVar,  set<Value*> globalVars, set<Value*> arguments, BBColorMap ColorMap) {
	if (!isReturnBlock(BB)) {
		ColorMap[BB] = EscapeDetect::GREY;
	}
	doBasicBlock(BB, &localVar, &globalVars, &arguments);
	TerminatorInst *TInst = BB->getTerminator();
	for (unsigned I = 0, NSucc = TInst->getNumSuccessors(); I < NSucc; ++I) {
      BasicBlock *Succ = TInst->getSuccessor(I);
      Color SuccColor = ColorMap[Succ];
      if (SuccColor == EscapeDetect::WHITE ||
			(SuccColor == EscapeDetect::GREY && NSucc == 1)) {
        recursiveDFSToposort(Succ, localVar, globalVars, arguments, ColorMap);
      }
    }
    // This BB is finished (fully explored)
    if (!isReturnBlock(BB)) {
		ColorMap[BB] = EscapeDetect::BLACK;
	}
}

void EscapeDetect::doBasicBlock(BasicBlock *BB,
	set<Value*> *localVar, set<Value*> *globalVars, set<Value*> *arguments) {
	for (auto &I : *BB) {
		//outs() << "--------Do Instruction " << &I << "---------\n";
		if (isa<ReturnInst>(I)) {
			//outs() << "Hit return instruction!\n";
			ReturnInst *returnInst = dyn_cast<ReturnInst>(&I);
			Value *returnValue = returnInst->getReturnValue();
			if (returnValue == nullptr) {
				//outs() << "The return value is void\n";	
				continue;
			} else if (!isa<PointerType>(returnValue->getType())) {
				//outs() << "The return value is not a pointer\n";
				continue;
			}
			returnValue = returnInst->getPrevNode()->getOperand(0);
			//outs() << "-Return value is: " << returnValue << "\n";
			
			if (isInSet(returnValue, localVar)) {
				printReport(&I, "Escapes from return value. Variable escaped is \'" + returnValue->getName().str() + "\'");			
			}
		} else if (isa<StoreInst>(I)) {
			bool success = false;
			StoreInst *storeInst = dyn_cast<StoreInst>(&I);
			if (!success)			
				success = success || checkGlobalVarEscape(localVar, globalVars, storeInst);
			if (!success)
				success = success || checkArgumentEscape(localVar, arguments, storeInst);
			if (!success)
				success = success || checkGlobalVar(localVar, globalVars, storeInst);
			if (!success)
				success = success || checkLocalVar(localVar, storeInst);
			if (!success)
				success = success || checkArguments(localVar, arguments, storeInst);
		} else if (isa<AllocaInst>(I)) {
			AllocaInst *allocaInst = dyn_cast<AllocaInst>(&I);
			Type *allocaType = allocaInst->getAllocatedType();
			if (isa<ArrayType>(*allocaType) || isa<IntegerType>(*allocaType)) {
				Value *value = dyn_cast<Value>(allocaInst);
				//outs() << allocaInst->getName() << " is a local variable\n";
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

bool EscapeDetect::checkGlobalVarEscape(set<Value*> *localVar, set<Value*> *globalVars, StoreInst *storeInst) {
	//outs() << "check global escape: " << storeInst << "\n";
	Value *src = storeInst->getOperand(0);
	Value *dst = storeInst->getOperand(1);
	
	if (isa<GEPOperator>(*src)) {
		GEPOperator *gep = dyn_cast<GEPOperator>(src);
		src = gep->getPointerOperand();
		//outs() << "src changed\n";
	}
	
	if (isInSet(dst, globalVars) &&
		isInSet(src, localVar)) {
		printReport(storeInst, "Escapes from global varibale. Variable escaped is \'" + src->getName().str() + "\'");
		return true;
	} else {
		return false;
	}
}

bool EscapeDetect::checkArgumentEscape(set<Value*> *localVar, set<Value*> *arguments, StoreInst *storeInst) {
	//outs() << "check argument escape: " << storeInst << "\n";
	Value *src = storeInst->getOperand(0);
	Value *dst = storeInst->getOperand(1);
	
	if (isa<GEPOperator>(*src)) {
		GEPOperator *gep = dyn_cast<GEPOperator>(src);
		src = gep->getPointerOperand();
		//outs() << "src changed\n";
	}
	
	if (!isInSet(src, localVar)) {
		return false;
	}
	
	Instruction *previousInst = storeInst->getPrevNode();
	if (isa<LoadInst>(*previousInst) || isa<GetElementPtrInst>(*previousInst)) {
		dst = previousInst->getOperand(0);
	}

	if (isInSet(dst, arguments)) {
		printReport(storeInst, "Escapes from function arguments. Variable escaped is \'" + src->getName().str() + "\'");
		return true;
	} else {
		return false;
	}
}

bool EscapeDetect::checkLocalVar(set<Value*> *localVar, StoreInst *storeInst) {
	Value *src = storeInst->getOperand(0);
	Value *dst = storeInst->getOperand(1);
	//outs() << "check store local var: " << storeInst << "\n";
	//check whether store constants
	if (isa<Constant>(*src)) {
		if (!isInSet(dst, localVar)) {
			//outs() << dst->getName() << " is a local variable\n";
			localVar->insert(dst);
		}
		//outs() << "1\n";
		return true;
	}
	//check whether assign local vars
	Instruction *previousInst = storeInst->getPrevNode();
	if (isa<LoadInst>(*previousInst) || isa<GetElementPtrInst>(*previousInst)) {
		src = previousInst->getOperand(0);
	}
	
	if (isInSet(src, localVar)) {
		if (!isInSet(dst, localVar)) {
			//outs() << dst->getName() << " is a local variable\n";
			localVar->insert(dst);
		}
		//outs() << "2\n";
		return true;
	}
	//outs() << storeInst << ": not a local store instruction\n";
	return false;
}

bool EscapeDetect::checkGlobalVar(set<Value*> *localVar, set<Value*> *globalVars, StoreInst *storeInst) {
	Value *src = storeInst->getOperand(0);
	Value *dst = storeInst->getOperand(1);
	//outs() << "check store global var: " << storeInst << "\n";
	if (isa<GEPOperator>(*src)) {
		GEPOperator *gep = dyn_cast<GEPOperator>(src);
		src = gep->getPointerOperand();
		//outs() << "src changed\n";
	}
	if (isInSet(src, globalVars)) {
		//outs() << "The local varibale is assigned with a global variable.\n";
		if (isInSet(dst, localVar)) {	
			localVar->erase(localVar->find(dst));
		}
		if (!isInSet(dst, globalVars)) {
			globalVars->insert(dst);
		}
		return true;
	} else {
		//outs() << storeInst << ": not a global store instruction\n";
		return false;
	}
}

bool EscapeDetect::checkArguments(set<Value*> *localVar, set<Value*> *arguments, StoreInst *storeInst) {
	Value *src = storeInst->getOperand(0);
	Value *dst = storeInst->getOperand(1);
	//outs() << "check store arguments: " << storeInst << "\n";
	if (isInSet(src, arguments)) {
		//outs() << "The argument is stored to a register.\n";
		if (!isInSet(dst, arguments)) {
			arguments->insert(dst);
		}
		return true;
	}
	return false;
}

void EscapeDetect::printReport(Instruction* inst, string message) {
	if (isInSet(inst, &errorInstructions)) {
		return;
	}
	errorInstructions.insert(inst);
	errs() << "WARNING: ";
    if (MDNode *n = inst->getMetadata("dbg")) {
		DILocation loc(n);
        unsigned line = loc.getLineNumber();
        StringRef file = loc.getFilename();
        StringRef dir = loc.getDirectory();
        errs() << "Line " << line << " of file " << file.str()
         << " in " << dir.str() << " in fucntion " << functionName <<": ";
    }
    errs() << message << "\n";
}

bool EscapeDetect::isPointerToPointer(const Value* V) {
    const Type* T = V->getType();
    return T->isPointerTy() && T->getContainedType(0)->isPointerTy();
}
