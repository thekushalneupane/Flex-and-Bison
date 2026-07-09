#ifndef SYMBOLTABLE_H
#define SYMBOLTABLE_H

#define MAX 100

typedef struct {
    char name[30];
    int value;
} Symbol;

void insertSymbol(char *name, int value);
int getValue(char *name);
int exists(char *name);
void displaySymbolTable();

#endif