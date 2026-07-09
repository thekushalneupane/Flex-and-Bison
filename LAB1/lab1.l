%{
#include<stdio.h>
%}
%%
[0-9]+  { printf("%s\n", yytext); }
.|\n    {}
%%
int yywrap(){}
int main(){
    yylex();
    return 0;
}