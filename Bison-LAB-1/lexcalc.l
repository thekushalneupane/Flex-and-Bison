%{
#include "parser.tab.h"
#include <stdlib.h>
%}

%%
    /* Bison default type is integer, so our calculator will only support integer numbers, not fractions, not floats */
[0-9]+      {
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