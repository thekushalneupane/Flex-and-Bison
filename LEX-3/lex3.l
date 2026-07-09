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
int errorCount = 0;

/* Brackets */
int roundB = 0;
int curlyB = 0;
int squareB = 0;

typedef struct {
    char name[100];
    int line;
} Symbol;

typedef struct {
    int line;
    char msg[200];
} ErrorRec;

Symbol symTable[MAX_SYMBOLS];
ErrorRec errTable[MAX_ERRORS];

int symIndex = 0;
int errIndex = 0;

/* SYMBOL TABLE */
void addSymbol(char *name)
{
    for(int i=0;i<symIndex;i++)
        if(strcmp(symTable[i].name,name)==0)
            return;

    strcpy(symTable[symIndex].name,name);
    symTable[symIndex].line = lineNo;
    symIndex++;
}

/* ERROR TABLE */
void addError(char *msg)
{
    errTable[errIndex].line = lineNo;
    strcpy(errTable[errIndex].msg,msg);
    errIndex++;
    errorCount++;
}

/* Making distinct tokens for keywords and identifiers */
/* Distinct token tracking */
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

/* ===== DEFINITIONS ===== */

DIGIT      [0-9]
LETTER     [a-zA-Z_]
ID         {LETTER}({LETTER}|{DIGIT})*

INT        [0-9]+
FLOAT      [0-9]+\.[0-9]+
HEX        0[xX][0-9a-fA-F]+
OCT        0[0-7]+

KEYWORD    int|float|double|char|void|main|if|else|for|while|return|break|continue

%%

^#.* {
    printf("PREPROCESSOR : %s (Line %d)\n",yytext,lineNo);
}

"//".* {
    printf("COMMENT : %s (Line %d)\n",yytext,lineNo);
}

\/\*([^*]|\*+[^*/])*\*+\/ {
    printf("COMMENT : %s (Line %d)\n",yytext,lineNo);
}

{KEYWORD} {
    printf("KEYWORD : %s (Line %d)\n",yytext,lineNo);
    keywordCount++; 
    if(isNewToken(yytext)) totalTokens++;
}


{ID} {
    printf("IDENTIFIER : %s (Line %d)\n",yytext,lineNo);
    addSymbol(yytext);
    identifierCount++;
    if(isNewToken(yytext)) totalTokens++;
}

{FLOAT} {
    printf("FLOAT : %s (Line %d)\n",yytext,lineNo);
    floatCount++; 
    if(isNewToken(yytext)) totalTokens++;
}

{HEX} {
    printf("HEX : %s (Line %d)\n",yytext,lineNo);
    hexCount++; 
    if(isNewToken(yytext)) totalTokens++;
}

{OCT} {
    printf("OCTAL : %s (Line %d)\n",yytext,lineNo);
    octalCount++; 
    if(isNewToken(yytext)) totalTokens++;
}

{INT} {
    printf("INTEGER : %s (Line %d)\n",yytext,lineNo);
    integerCount++; 
    if(isNewToken(yytext)) totalTokens++;
}

[0-9]+[a-zA-Z_][a-zA-Z0-9_]* {
    printf("ERROR : Invalid Identifier %s (Line %d)\n", yytext, lineNo);
    addError("Invalid Identifier");
    if(isNewToken(yytext)) totalTokens++;
}

\"([^\"\\]|\\.)*\" {
    printf("STRING : %s (Line %d)\n",yytext,lineNo);
    stringCount++; 
    if(isNewToken(yytext)) totalTokens++;
}

\'([^\'\\]|\\.)\' {
    printf("CHAR : %s (Line %d)\n",yytext,lineNo);
    charCount++; 
    if(isNewToken(yytext)) totalTokens++;
}


"+"|"-"|"*"|"/"|"%"|"="|"<"|">"|"!" {
    printf("OPERATOR : %s (Line %d)\n",yytext,lineNo);
    operatorCount++; 
    if(isNewToken(yytext)) totalTokens++;
}




"(" { 
        printf("SYMBOL : ( (Line %d)\n",lineNo); 
        roundB++; symbolCount++; 
        if(isNewToken(yytext))
             totalTokens++;; 
    }


")" { printf("SYMBOL : ) (Line %d)\n",lineNo); roundB--; symbolCount++; if(isNewToken(yytext)) totalTokens++;; }

"{" { printf("SYMBOL : { (Line %d)\n",lineNo); curlyB++; symbolCount++; if(isNewToken(yytext)) totalTokens++;; }
"}" { printf("SYMBOL : } (Line %d)\n",lineNo); curlyB--; symbolCount++; if(isNewToken(yytext)) totalTokens++;; }

"[" { printf("SYMBOL : [ (Line %d)\n",lineNo); squareB++; symbolCount++; if(isNewToken(yytext)) totalTokens++;; }
"]" { printf("SYMBOL : ] (Line %d)\n",lineNo); squareB--; symbolCount++; if(isNewToken(yytext)) totalTokens++;; }

";"|","|":" {
    printf("SYMBOL : %s (Line %d)\n",yytext,lineNo);
    symbolCount++; 
    if(isNewToken(yytext)) totalTokens++;
}

[ \t\r]+ { }

\n { lineNo++; }

. {
    printf("ERROR : Illegal %s (Line %d)\n",yytext,lineNo);
    addError("Illegal Character");
}

%%

/* ================= MAIN ================= */
int main()
{
    yyin = fopen("input.c","r");

    if(!yyin)
    {
        printf("Cannot open file\n");
        return 1;
    }

    yylex();
    fclose(yyin);

    printf("\n========== SYMBOL TABLE ==========\n");
    for(int i=0;i<symIndex;i++)
        printf("%s -> Line %d\n",symTable[i].name,symTable[i].line);

    printf("\n========== SUMMARY ==========\n");
    printf("Keywords: %d\n",keywordCount);
    printf("Identifiers: %d\n",identifierCount);
    printf("Integers: %d\n",integerCount);
    printf("Floats: %d\n",floatCount);
    printf("Hex: %d\n",hexCount);
    printf("Octal: %d\n",octalCount);
    printf("Strings: %d\n",stringCount);
    printf("Chars: %d\n",charCount);
    printf("Operators: %d\n",operatorCount);
    printf("Symbols: %d\n",symbolCount);
    printf("Errors: %d\n",errorCount);
    printf("Total Tokens: %d\n",totalTokens);

    printf("\nBracket Check:\n");
    printf("() %s\n", roundB==0?"Balanced":"Not Balanced");
    printf("{} %s\n", curlyB==0?"Balanced":"Not Balanced");
    printf("[] %s\n", squareB==0?"Balanced":"Not Balanced");

    return 0;
}

int yywrap(){ return 1; }