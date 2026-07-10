#include <stdio.h>
#include <string.h>
#include "symbol.h"

#define MAX 100

Symbol table[MAX];
int count = 0;

int find(char *name)
{
    for(int i=0;i<count;i++)
        if(strcmp(table[i].name,name)==0)
            return i;
    return -1;
}

void insert(char *name, int value)
{
    int p = find(name);

    if(p == -1)
    {
        strcpy(table[count].name, name);
        table[count].value = value;
        count++;
    }
    else
    {
        table[p].value = value;
    }
}

int get(char *name)
{
    int p = find(name);
    if(p == -1)
    {
        printf("Error: %s not defined\n", name);
        return 0;
    }
    return table[p].value;
}

void display()
{
    printf("\n--- SYMBOL TABLE ---\n");
    for(int i=0;i<count;i++)
        printf("%s = %d\n", table[i].name, table[i].value);
}