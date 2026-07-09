#ifndef SYMBOLTABLE_H
#define SYMBOLTABLE_H

#define MAX 100

typedef struct {
    char name[30];
    int value;
    int initialized;   // NEW: 0 = no, 1 = yes
} Symbol;

void insertSymbol(char *name, int value);
int exists(char *name);
int getValue(char *name);
int isInitialized(char *name);
void displaySymbolTable();

#endif