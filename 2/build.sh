#!/bin/bash

clang++ -std=c++11 -o Bonus Bonus.cpp `llvm-config --cxxflags` `llvm-config --ldflags` `llvm-config --libs` -lpthread -lncurses -ldl

