%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *s);
int yylex();
%}

/* Token declaration */
%token NUMBER
%token NEWLINE   /*Token for NEWLINE*/
%define api.value.type {double} /*using double instead of int for accepting fraction values/*

/* Operator precedence */
%left '+' '-'
%left '*' '/'
%right UMINUS
%left '%'

%%

/*RECURSIVE FUNCTION for accepting multiple expressions*/

input 
        : /*empty line*/
        | input line
        ;

line
        : expression NEWLINE    /*address NEWLINE as finish of expression after hit enter*/
            {
                printf("\nAnswer = %f\n", $1);
                printf("Enter Expression: ");
            }
        | NEWLINE
            {
               printf("Enter Expression: "); 
            }
        ;

expression

        : expression '+' expression
            {
                $$=$1+$3;
            }

        | expression '-' expression
            {
                $$=$1-$3;
            }

        | expression '*' expression
            {
                $$=$1*$3;
            }

        | expression '/' expression
            {
                if($3==0)
                {
                    printf("Division by zero\n");
                    exit(1);
                }

                $$=$1/$3;
            }

        | '(' expression ')'
            {
                $$=$2;
            }

        | '{' expression '}'
            {
                $$ = $2;
            }

        | '[' expression ']'
            {
                $$ = $2;
            }

        | '-' expression %prec UMINUS
            {
                $$=-$2;
            }

        | NUMBER
            {
                $$=$1;
            }

        | expression '%'
            {
                $$ = $1 / 100;
            }

        ;

%%

void yyerror(const char *s)
{
    printf("Syntax Error : %s\n",s);
}

int main()
{
    printf("Enter Expression : ");

    yyparse();

    return 0;
}