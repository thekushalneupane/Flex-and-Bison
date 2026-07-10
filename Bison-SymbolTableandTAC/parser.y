%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbol.h"

extern FILE *yyin;
extern int yylex();
void yyerror(const char *s);

int temp = 0;
int label = 0;

char* newTemp()
{
    char *t = malloc(10);
    sprintf(t,"t%d",temp++);
    return t;
}

char* newLabel()
{
    char *l = malloc(10);
    sprintf(l,"L%d",label++);
    return l;
}

%}

%union {
    int val;
    char id[30];
}

%token <val> NUM
%token <id> ID
%token IF ELSE WHILE
%token LT GT EQ NE

%type <val> expr condition

%left '+' '-'
%left '*' '/'

%%

program:
    stmts
    {
        display();
        printf("\nCompilation Finished\n");
    }
;

stmts:
    stmts stmt
    | stmt
;

/* ---------------- ASSIGNMENT ---------------- */

stmt:
ID '=' expr ';'
{
    printf("%s = %d\n", $1, $3);
    insert($1, $3);   // ✔ REAL UPDATE
}

/* ---------------- IF-ELSE ---------------- */

| IF '(' condition ')'
{
    char *L1 = newLabel();
    printf("ifFalse %d goto %s\n", $3, L1);
}
stmt
{
    char *L2 = newLabel();
    printf("goto %s\n", L2);
    printf("L1:\n");
}
ELSE
stmt
{
    printf("L2:\n");
}

/* ---------------- WHILE ---------------- */

| WHILE '(' condition ')'
{
    char *L1 = newLabel();
    printf("L_start:\n");
    printf("ifFalse %d goto L_end\n", $3);
}
stmt
{
    printf("goto L_start\nL_end:\n");
}

;

/* ---------------- CONDITIONS ---------------- */

condition:
expr LT expr { $$ = $1 < $3; printf("t_cond = %d < %d\n",$1,$3); }
| expr GT expr { $$ = $1 > $3; printf("t_cond = %d > %d\n",$1,$3); }
| expr EQ expr { $$ = $1 == $3; printf("t_cond = %d == %d\n",$1,$3); }
| expr NE expr { $$ = $1 != $3; printf("t_cond = %d != %d\n",$1,$3); }
;

/* ---------------- EXPRESSIONS (REAL EVALUATION) ---------------- */

expr:
NUM { $$ = $1; }

| ID { $$ = get($1); }

| expr '+' expr { $$ = $1 + $3; printf("t = %d + %d\n",$1,$3); }

| expr '-' expr { $$ = $1 - $3; printf("t = %d - %d\n",$1,$3); }

| expr '*' expr { $$ = $1 * $3; printf("t = %d * %d\n",$1,$3); }

| expr '/' expr { $$ = $1 / $3; printf("t = %d / %d\n",$1,$3); }
;

%%

void yyerror(const char *s)
{
    printf("Error: %s\n", s);
}

int main()
{
    FILE *fp = fopen("input.txt","r");
    if(!fp)
    {
        printf("File error\n");
        return 1;
    }

    yyin = fp;
    yyparse();
    fclose(fp);
}