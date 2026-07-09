%{
#include "parser.tab.h"
#include <string.h>
#include <stdlib.h>
%}

%%

[ \t\r\n]+          ;

[0-9]+              {
                        yylval.num = atoi(yytext);
                        return NUMBER;
                    }

[a-zA-Z_][a-zA-Z0-9_]* {
                        strcpy(yylval.id, yytext);
                        return ID;
                    }

"+"     return '+';
"-"     return '-';
"*"     return '*';
"/"     return '/';
"="     return '=';
";"     return ';';
"("     return '(';
")"     return ')';

.       { printf("Unknown: %s\n", yytext); }

%%

int yywrap()
{
    return 1;   // IMPORTANT: tells EOF reached
}