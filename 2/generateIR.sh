#!/bin/bash

cd tests
clang -g -S -emit-llvm -c *.c

