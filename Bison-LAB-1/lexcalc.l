%{
#include "parser.tab.h"
#include <stdlib.h>
%}

%%
    /* Bison default type is integer, so our calculator will only support integer numbers, not fractions, not floats */
    /*this rule [0-9]+ only read the integer part of the number, for floating point numbers we need to chnage the rule
    so we need to chnage the rule to :*/
[0-9]+(\.[0-9]+)?      {
                yylval = atof(yytext);
                return NUMBER;
            }

"+"         return '+';
"-"         return '-';
"*"         return '*';
"/"         return '/';
"("         return '(';
")"         return ')';
"{"         return '{';
"}"         return '}';
"["         return '[';
"]"         return ']';

[ \t]     ;

"\n"      return NEWLINE;

.           {
                printf("Unknown character : %s\n",yytext);
            }

%%

int yywrap()
{
    return 1;
}