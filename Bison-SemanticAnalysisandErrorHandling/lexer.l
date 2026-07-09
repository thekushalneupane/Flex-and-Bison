%{
#include "parser.tab.h"
#include <stdlib.h>
#include <string.h>
%}

%%

[ \t\r\n]+ ;

[0-9]+ {
    yylval.num = atoi(yytext);
    return NUMBER;
}

[a-zA-Z_][a-zA-Z0-9_]* {
    strcpy(yylval.id, yytext);
    return ID;
}

"+" return '+';
"-" return '-';
"*" return '*';
"/" return '/';
"=" return '=';
";" return ';';
"(" return '(';
")" return ')';

. {
    printf("Unknown character: %s\n", yytext);
}

%%

int yywrap()
{
    return 1;
}