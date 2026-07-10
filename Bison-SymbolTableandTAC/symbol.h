#ifndef SYMBOL_H
#define SYMBOL_H

typedef struct {
    char name[30];
    int value;
} Symbol;

void insert(char *name, int value);
int get(char *name);
void display();

#endif