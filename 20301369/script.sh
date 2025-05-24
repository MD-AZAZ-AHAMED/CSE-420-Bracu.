#!/bin/bash

yacc -d -y -v 1805001.y
flex 1805001.l
g++ -std=c++17 -o compiler lex.yy.c y.tab.c symbol_table.cpp scope_table.cpp
./compiler input.c