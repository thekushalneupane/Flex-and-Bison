%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symboltable.h"

extern FILE *yyin;
extern int yylex();
void yyerror(const char *s);

%}

%union {
    int num;
    char id[30];
}

%token <num> NUMBER
%token <id> ID

%type <num> expr

%left '+' '-'
%left '*' '/'

%%

program:
    statements
    {
        printf("\nParsing Completed\n");
        displaySymbolTable();
    }
;

statements:
    statements statement
    | statement
;

statement:
    ID '=' expr ';'
    {
        insertSymbol($1, $3);
        printf("%s = %d\n", $1, $3);
    }

    | error ';'
    {
        printf("Recovered from error, skipping statement\n");
        yyerrok;
    }
;

expr:
    NUMBER
    {
        $$ = $1;
    }

    | ID
    {
        if(!isInitialized($1))
        {
            printf("Semantic Error: %s used before assignment\n", $1);
            $$ = 0;
        }
        else
        {
            $$ = getValue($1);
        }
    }

    | expr '+' expr { $$ = $1 + $3; }
    | expr '-' expr { $$ = $1 - $3; }
    | expr '*' expr { $$ = $1 * $3; }
    | expr '/' expr { $$ = $1 / $3; }

    | '(' expr ')' { $$ = $2; }
;

%%

void yyerror(const char *s)
{
    printf("Syntax Error: %s\n", s);
}

int main()
{
    FILE *fp = fopen("input.txt","r");

    if(!fp)
    {
        printf("Cannot open file\n");
        return 1;
    }

    yyin = fp;

    yyparse();

    fclose(fp);

    return 0;
}