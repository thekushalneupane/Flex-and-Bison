%{
    #include<stdio.h>
%}
digit[0-9]
letter[A-Z a-z]
id (letter)(letter|digit)*
%%
{digit}+ {printf("number: %s\n", yytext);}
{id} {printf("identifier: %s\n", yytext);}
. {printf("unknown: %s\n", yytext);}
%%
int main() {
    yylex();
    return 0;
}
int yywrap(){}