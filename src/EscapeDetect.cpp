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
	AliasMap globalAliasMap;
	for (Module::global_iterator i = module->global_begin(); i!= module->global_end(); i++)	{	
		GlobalVariable *g = i;
		if(isa<PointerType>(g->getType())) {
			//outs() << g->getName() << " is a pointer\n" ;
			globalAliasMap[g] = g;
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
		AliasMap argumentsAliasMap;
		//outs() << " Testing function arguments...\n";
		for (auto &arg : F.getArgumentList()) {
			if(isPointerToPointer(&arg)) {
				
				//outs() << arg.getName() << " is a pointer to pointer\n" ;
				argumentsAliasMap[&arg] = &arg;
			}
		}
		//outs() << " Function arguments done.\n";
		AliasMap localAliasMap = AliasMap();
		BBColorMap ColorMap;
		for (Function::const_iterator I = F.begin(), IE = F.end(); I != IE; ++I) {
      		ColorMap[I] = EscapeDetect::WHITE;
    	}
		recursiveDFSToposort(&F.getEntryBlock(), localAliasMap, globalAliasMap, argumentsAliasMap, ColorMap);
		//outs() << F.getName() << " done.\n";
	}
}

void EscapeDetect::recursiveDFSToposort(BasicBlock *BB, 
	AliasMap localAliasMap,  AliasMap globalAliasMap, AliasMap argumentsAliasMap, BBColorMap ColorMap) {
	if (!isReturnBlock(BB)) {
		ColorMap[BB] = EscapeDetect::GREY;
	}
	doBasicBlock(BB, &localAliasMap, &globalAliasMap, &argumentsAliasMap);
	TerminatorInst *TInst = BB->getTerminator();
	for (unsigned I = 0, NSucc = TInst->getNumSuccessors(); I < NSucc; ++I) {
      BasicBlock *Succ = TInst->getSuccessor(I);
      Color SuccColor = ColorMap[Succ];
      if (SuccColor == EscapeDetect::WHITE ||
			(SuccColor == EscapeDetect::GREY && NSucc == 1)) {
        recursiveDFSToposort(Succ, localAliasMap, globalAliasMap, argumentsAliasMap, ColorMap);
      }
    }
    // This BB is finished (fully explored)
    if (!isReturnBlock(BB)) {
		ColorMap[BB] = EscapeDetect::BLACK;
	}
}

void EscapeDetect::doBasicBlock(BasicBlock *BB,
	AliasMap *localAliasMap,  AliasMap *globalAliasMap, AliasMap *argumentsAliasMap) {
	for (auto &I : *BB) {
		//outs() << "--------Do Instruction " << &I << "---------\n";
		if (isa<ReturnInst>(I)) {
			//outs() << "Processing return instruction\n";
			ReturnInst *returnInst = dyn_cast<ReturnInst>(&I);
			handleReturnInst(returnInst, localAliasMap);
		} else if (isa<StoreInst>(I)) {
			//outs() << "Processing store instruction\n";
			StoreInst *storeInst = dyn_cast<StoreInst>(&I);
			handleStoreInst(storeInst, localAliasMap, globalAliasMap, argumentsAliasMap);
		} else if (isa<AllocaInst>(I)) {
			//outs() << "Processing alloca instruction\n";
			AllocaInst *allocaInst = dyn_cast<AllocaInst>(&I);
			handleAllocaInst(allocaInst, localAliasMap);
		} else if (isa<LoadInst>(I)) {
			//outs() << "Processing load instruction\n";
			LoadInst *loadInst = dyn_cast<LoadInst>(&I);
			handleLoadInst(loadInst, localAliasMap, globalAliasMap, argumentsAliasMap);
		} else if (isa<GEPOperator>(I)) {
			//outs() << "Processing gep instruction\n";
			GEPOperator *GEPInst = dyn_cast<GEPOperator>(&I);
			handleGEPInst(GEPInst, localAliasMap, globalAliasMap, argumentsAliasMap);			
		}
	}
}

void EscapeDetect::handleReturnInst(ReturnInst *returnInst, AliasMap *localAliasMap) {
	Value *returnValue = returnInst->getReturnValue();
	if (returnValue == nullptr) {
		//outs() << "The return value is void\n";	
		return;
	} else if (!isa<PointerType>(returnValue->getType())) {
		//outs() << "The return value is not a pointer\n";
		return;
	}
	returnValue = returnInst->getPrevNode()->getOperand(0);
	if (isInMap(returnValue, localAliasMap)) {
		AliasMap &aReference = *localAliasMap;
		StringRef varName = aReference[returnValue]->getName();
		printReport(returnInst, "Escapes from return value. Variable escaped is \'" + varName.str() + "\'");
	}
}

void EscapeDetect::handleStoreInst(StoreInst *storeInst,
	AliasMap *localAliasMap,  AliasMap *globalAliasMap, AliasMap *argumentsAliasMap) {
	bool success = false;
	if (!success)			
		success = success || checkGlobalVarEscape(localAliasMap, globalAliasMap, storeInst);
	if (!success)
		success = success || checkArgumentEscape(localAliasMap, argumentsAliasMap, storeInst);
	if (!success)
		success = success || checkGlobalVar(localAliasMap, globalAliasMap, argumentsAliasMap, storeInst);
	if (!success)
		success = success || checkLocalVar(localAliasMap, globalAliasMap, argumentsAliasMap, storeInst);
	if (!success)
		success = success || checkArguments(localAliasMap, globalAliasMap, argumentsAliasMap, storeInst);
}

void EscapeDetect::handleAllocaInst(AllocaInst *allocaInst, AliasMap *localAliasMap) {
	//Type *allocaType = allocaInst->getAllocatedType();
	Value *value = dyn_cast<Value>(allocaInst);
	AliasMap &aReference = *localAliasMap;
	aReference[allocaInst] = allocaInst;
}

void EscapeDetect::handleLoadInst(LoadInst *loadInst, AliasMap *localAliasMap, AliasMap *globalAliasMap, AliasMap *argumentsAliasMap)
{
	Value *src = loadInst->getOperand(0);
	Value *dst = loadInst;

	if (isInMap(src, localAliasMap)) {
		addToMap(localAliasMap, dst, src);
	} else if (isInMap(src, globalAliasMap)) {
		addToMap(globalAliasMap, dst, src);
	} else if (isInMap(src, argumentsAliasMap)) {
		addToMap(argumentsAliasMap, dst, src);
	}
}
void EscapeDetect::handleGEPInst(GEPOperator *gepInst, AliasMap *localAliasMap, AliasMap *globalAliasMap, AliasMap *argumentsAliasMap)
{
	Value *src = gepInst->getOperand(0);
	Value *dst = gepInst;

	if (isInMap(src, localAliasMap)) {
		addToMap(localAliasMap, dst, src);
	} else if (isInMap(src, globalAliasMap)) {
		addToMap(globalAliasMap, dst, src);
	} else if (isInMap(src, argumentsAliasMap)) {
		addToMap(argumentsAliasMap, dst, src);
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

bool EscapeDetect::checkGlobalVarEscape(AliasMap *localAliasMap, AliasMap *globalAliasMap, StoreInst *storeInst) {
	//outs() << "check global escape: " << storeInst << "\n";
	Value *src = storeInst->getOperand(0);
	Value *dst = storeInst->getOperand(1);
	
	if (isInMap(src, localAliasMap) &&
		isInMap(dst, globalAliasMap)) {
		AliasMap &aReference = *localAliasMap;
		StringRef varName = aReference[src]->getName();
		printReport(storeInst, "Escapes from global varibale. Variable escaped is \'" + varName.str() + "\'");
		return true;
	} else {
		return false;
	}
}

bool EscapeDetect::checkArgumentEscape(AliasMap *localAliasMap, AliasMap *argumentsAliasMap, StoreInst *storeInst) {
	Value *src = storeInst->getOperand(0);
	Value *dst = storeInst->getOperand(1);

	if (isInMap(src, localAliasMap) &&
		isInMap(dst, argumentsAliasMap)) {
		AliasMap &aReference = *localAliasMap;
		StringRef varName = aReference[src]->getName();
		printReport(storeInst, "Escapes from function arguments. Variable escaped is \'" + varName.str() + "\'");
		return true;
	} else {
		return false;
	}
}

bool EscapeDetect::checkLocalVar(AliasMap *localAliasMap, AliasMap *globalAliasMap, AliasMap *argumentsAliasMap, StoreInst *storeInst) {
	Value *src = storeInst->getOperand(0);
	Value *dst = storeInst->getOperand(1);

	if (isa<Constant>(*src) || isInMap(src, localAliasMap)) {
		addToMap(localAliasMap, dst, src);
		
		if (isInMap(dst, globalAliasMap)) {
			globalAliasMap->erase(globalAliasMap->find(dst));
		} else if (isInMap(dst, argumentsAliasMap)) {
			argumentsAliasMap->erase(argumentsAliasMap->find(dst));
		}
		return true;
	} else {
		return false;
	}
}

bool EscapeDetect::checkGlobalVar(AliasMap *localAliasMap, AliasMap *globalAliasMap, AliasMap *argumentsAliasMap, StoreInst *storeInst) {
	Value *src = storeInst->getOperand(0);
	Value *dst = storeInst->getOperand(1);

	if (isInMap(src, globalAliasMap)) {
		addToMap(globalAliasMap, dst, src);
		
		if (isInMap(dst, localAliasMap)) {
			localAliasMap->erase(localAliasMap->find(dst));
		} else if (isInMap(dst, argumentsAliasMap)) {
			argumentsAliasMap->erase(argumentsAliasMap->find(dst));
		}
		return true;
	} else {
		return false;
	}
}

bool EscapeDetect::checkArguments(AliasMap *localAliasMap, AliasMap *globalAliasMap, AliasMap *argumentsAliasMap, StoreInst *storeInst) {
	Value *src = storeInst->getOperand(0);
	Value *dst = storeInst->getOperand(1);

	if (isInMap(src, argumentsAliasMap)) {
		addToMap(argumentsAliasMap, dst, src);

		if (isInMap(dst, localAliasMap)) {
			localAliasMap->erase(localAliasMap->find(dst));
		}else if (isInMap(dst, globalAliasMap)) {
			globalAliasMap->erase(globalAliasMap->find(dst));
		}
		return true;
	} else {
		return false;
	}
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

bool EscapeDetect::isInMap(Value* aValue, AliasMap *aMap) {
	bool result = aMap->find(aValue) != aMap->end();
	//outs() << "is in map: " << result << "\n";
	return result;
}

void EscapeDetect::addToMap(AliasMap* aMap, Value* v1, Value* v2) {
	AliasMap &aReference = *aMap;	
	if (isInMap(v2, aMap)) {
		//outs() << v2 << " is in map " << aMap << "\n";
		//outs() << v2 << " maps to " << aMap->lookup(v2) << "\n";
		aReference[v1] = aReference[aReference[v2]];
	} else {
		//outs() << "v2 is a constant!!\n";
		aReference[v1] = aReference[v1];		
	}
}
