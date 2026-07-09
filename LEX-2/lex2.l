%{
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

#define MAX_SYMBOLS 500
#define MAX_ERRORS 500

extern FILE *yyin;

/* Counters */
int lineNo = 1;
int totalTokens = 0;
int totalChars = 0;

int keywordCount = 0;
int identifierCount = 0;
int integerCount = 0;
int floatCount = 0;
int octalCount = 0;
int hexCount = 0;
int stringCount = 0;
int charCount = 0;
int operatorCount = 0;
int symbolCount = 0;
int commentCount = 0;
int preprocessorCount = 0;
int errorCount = 0;

/* Bracket counters */
int roundBracket = 0;
int curlyBracket = 0;
int squareBracket = 0;

typedef struct
{
    char name[100];
    int line;
} Symbol;

typedef struct
{
    int line;
    char msg[200];
} ErrorRec;

Symbol symTable[MAX_SYMBOLS];
ErrorRec errTable[MAX_ERRORS];

int symIndex = 0;
int errIndex = 0;

void addSymbol(char *name)
{
    for(int i=0;i<symIndex;i++)
    {
        if(strcmp(symTable[i].name,name)==0)
            return;
    }

    strcpy(symTable[symIndex].name,name);
    symTable[symIndex].line=lineNo;
    symIndex++;
}

void addError(char *msg)
{
    errTable[errIndex].line=lineNo;
    strcpy(errTable[errIndex].msg,msg);
    errIndex++;
    errorCount++;
}

char seenTokens[1000][100];
int seenCount = 0;

int isNewToken(char *token)
{
    for(int i = 0; i < seenCount; i++)
        if(strcmp(seenTokens[i], token) == 0)
            return 0;
    strcpy(seenTokens[seenCount], token);
    seenCount++;
    return 1;
}

%}

/* ---------- Definitions ---------- */

DIGIT      [0-9]
LETTER     [a-zA-Z_]

ID         {LETTER}({LETTER}|{DIGIT})*

INTCONST   [0-9]+

FLOATCONST [0-9]+\.[0-9]+

HEXCONST   0[xX][0-9a-fA-F]+

OCTCONST   0[0-7]+

KEYWORD    auto|break|case|char|const|continue|default|do|double|else|enum|extern|float|for|goto|if|int|long|register|return|short|signed|sizeof|static|struct|switch|typedef|union|unsigned|void|volatile|while

%%


^#.* {
    printf("PREPROCESSOR : %s\n",yytext);
    preprocessorCount++;
    if(isNewToken(yytext)) totalTokens++;
}


"//".* {
    printf("COMMENT      : %s\n",yytext);
    commentCount++;
    if(isNewToken(yytext)) totalTokens++;
}

\/\*([^*]|\*+[^*/])*\*+\/ {
    printf("COMMENT      : %s\n",yytext);
    commentCount++;
    if(isNewToken(yytext)) totalTokens++;
}


[0-9]+[a-zA-Z_][a-zA-Z0-9_]* {
    printf("ERROR        : Invalid Identifier %s (Line %d)\n",
           yytext,lineNo);

    addError("Invalid Identifier");
}

[0-9]+\.[0-9]+\.[0-9]+ {
    printf("ERROR        : Invalid Float %s (Line %d)\n",
           yytext,lineNo);

    addError("Invalid Float");
}


0[0-7]*[89][0-9]* {
    printf("ERROR        : Invalid Octal %s (Line %d)\n",
           yytext,lineNo);

    addError("Invalid Octal");
}


{KEYWORD} {
    printf("KEYWORD      : %s (Line %d)\n",
           yytext,lineNo);

    keywordCount++;
    if(isNewToken(yytext)) totalTokens++;
}


{ID} {
    printf("IDENTIFIER   : %s (Line %d)\n",
           yytext,lineNo);

    addSymbol(yytext);

    identifierCount++;
    if(isNewToken(yytext)) totalTokens++;
}


{FLOATCONST} {
    printf("FLOAT        : %s\n",yytext);

    floatCount++;
    if(isNewToken(yytext)) totalTokens++;
}


{OCTCONST} {
    printf("OCTAL        : %s\n",yytext);

    octalCount++;
    if(isNewToken(yytext)) totalTokens++;
}

{INTCONST} {
    printf("INTEGER      : %s\n",yytext);

    integerCount++;
    if(isNewToken(yytext)) totalTokens++;
}


\"([^\"\\]|\\.)*\" {
    printf("STRING       : %s\n",yytext);

    stringCount++;
    if(isNewToken(yytext)) totalTokens++;
}


\'([^\'\\]|\\.)\' {
    printf("CHARACTER    : %s\n",yytext);

    charCount++;
    if(isNewToken(yytext)) totalTokens++;
}


"++"|"--"|"+="|"-="|"*="|"/="|"%="|"=="|"!="|">="|"<="|"&&"|"||"|">>"|"<<"|"+"|"-"|"*"|"/"|"%"|"="|"<"|">"|"!" {
    printf("OPERATOR     : %s\n",yytext);

    operatorCount++;
    if(isNewToken(yytext)) totalTokens++;
}


"(" {
    printf("SYMBOL       : (\n");
    roundBracket++;
    symbolCount++;
    if(isNewToken(yytext)) totalTokens++;
}

")" {
    printf("SYMBOL       : )\n");
    roundBracket--;
    symbolCount++;
    if(isNewToken(yytext)) totalTokens++;
}

"{" {
    printf("SYMBOL       : {\n");
    curlyBracket++;
    symbolCount++;
    if(isNewToken(yytext)) totalTokens++;
}

"}" {
    printf("SYMBOL       : }\n");
    curlyBracket--;
    symbolCount++;
    if(isNewToken(yytext)) totalTokens++;
}

"[" {
    printf("SYMBOL       : [\n");
    squareBracket++;
    symbolCount++;
    if(isNewToken(yytext)) totalTokens++;
}

"]" {
    printf("SYMBOL       : ]\n");
    squareBracket--;
    symbolCount++;
    if(isNewToken(yytext)) totalTokens++;
}

";"|","|":" {
    printf("SYMBOL       : %s\n",yytext);

    symbolCount++;
    if(isNewToken(yytext)) totalTokens++;
}


[ \t\r]+ {
    totalChars += yyleng;
}

\n {
    lineNo++;
    totalChars++;
}


. {
    char msg[200];

    sprintf(msg,"Illegal Character %s",yytext);

    printf("ERROR        : Illegal Character %s (Line %d)\n",
           yytext,lineNo);

    addError(msg);
}

%%

int main()
{
    yyin = fopen("input.c","r");

    if(yyin==NULL)
    {
        printf("Cannot open input.c\n");
        return 1;
    }

    yylex();

    fclose(yyin);

    printf("\n====================================\n");
    printf("SYMBOL TABLE\n");
    printf("====================================\n");

    printf("%-20s %-10s\n","IDENTIFIER","LINE");

    for(int i=0;i<symIndex;i++)
    {
        printf("%-20s %-10d\n",
               symTable[i].name,
               symTable[i].line);
    }

    printf("\n====================================\n");
    printf("ERROR TABLE\n");
    printf("====================================\n");

    for(int i=0;i<errIndex;i++)
    {
        printf("Line %-5d %s\n",
               errTable[i].line,
               errTable[i].msg);
    }

    printf("\n====================================\n");
    printf("SUMMARY\n");
    printf("====================================\n");

    printf("Keywords      : %d\n",keywordCount);
    printf("Identifiers   : %d\n",identifierCount);
    printf("Integers      : %d\n",integerCount);
    printf("Floats        : %d\n",floatCount);
    printf("Hexadecimals  : %d\n",hexCount);
    printf("Octals        : %d\n",octalCount);
    printf("Strings       : %d\n",stringCount);
    printf("Characters    : %d\n",charCount);
    printf("Operators     : %d\n",operatorCount);
    printf("Symbols       : %d\n",symbolCount);
    printf("Comments      : %d\n",commentCount);
    printf("Preprocessor  : %d\n",preprocessorCount);
    printf("Errors        : %d\n",errorCount);
    printf("Total Tokens  : %d\n",totalTokens);

    printf("\nBracket Status\n");

    printf("() : %s\n",
           roundBracket==0 ? "Balanced" : "Not Balanced");

    printf("{} : %s\n",
           curlyBracket==0 ? "Balanced" : "Not Balanced");

    printf("[] : %s\n",
           squareBracket==0 ? "Balanced" : "Not Balanced");

    return 0;
}

int yywrap()
{
    return 1;
}