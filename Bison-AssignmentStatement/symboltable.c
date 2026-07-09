#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "symboltable.h"

Symbol table[MAX];
int count = 0;

int exists(char *name)
{
    for(int i=0;i<count;i++)
        if(strcmp(table[i].name,name)==0)
            return i;

    return -1;
}

void insertSymbol(char *name, int value)
{
    int pos = exists(name);

    if(pos == -1)
    {
        strcpy(table[count].name, name);
        table[count].value = value;
        count++;
    }
    else
    {
        table[pos].value = value;
    }
}

int getValue(char *name)
{
    int pos = exists(name);

    if(pos == -1)
    {
        printf("Semantic Error: %s not declared\n", name);
        return 0;
    }

    return table[pos].value;
}

void displaySymbolTable()
{
    printf("\n--------- SYMBOL TABLE ----------\n");
    printf("Variable\tValue\n");

    for(int i=0;i<count;i++)
        printf("%s\t\t%d\n", table[i].name, table[i].value);
}