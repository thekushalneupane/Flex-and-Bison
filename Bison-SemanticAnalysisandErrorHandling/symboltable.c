#include <stdio.h>
#include <string.h>
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
        table[count].initialized = 1;
        count++;
    }
    else
    {
        table[pos].value = value;
        table[pos].initialized = 1;
    }
}

int isInitialized(char *name)
{
    int pos = exists(name);

    if(pos == -1)
        return 0;

    return table[pos].initialized;
}

int getValue(char *name)
{
    int pos = exists(name);

    if(pos == -1)
        return 0;

    return table[pos].value;
}

void displaySymbolTable()
{
    printf("\n--------- SYMBOL TABLE ----------\n");
    printf("Variable\tValue\tInit\n");

    for(int i=0;i<count;i++)
        printf("%s\t\t%d\t%d\n",
            table[i].name,
            table[i].value,
            table[i].initialized);
}