#!/bin/bash
clang++ -std=c++11 -o UseAfterFree UseAfterFree.cpp `llvm-config --cxxflags` `llvm-config --ldflags` `llvm-config --libs` -lpthread -lncurses -ldl
