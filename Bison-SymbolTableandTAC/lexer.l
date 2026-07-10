%{
#include "parser.tab.h"
#include <stdlib.h>
#include <string.h>
%}

%%

[ \t\r\n]+ ;

"if"     return IF;
"else"   return ELSE;
"while"  return WHILE;

"<" return LT;
">" return GT;
"==" return EQ;
"!=" return NE;

[0-9]+ { yylval.val = atoi(yytext); return NUM; }

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

%%

int yywrap(){ return 1; }