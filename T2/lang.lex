%option noyywrap

%{
#include <stdio.h>
#include <string.h>
#include <string.h>
#include "lang.tab.h"
void extern yyerror(char*);
void TokenInvalido();
int yycolumn = 1;

char* removeQuotes(char* literal){
    char* newLiteral = (char*)malloc(sizeof(literal)-(2*sizeof(char)));
    int i;
    for(i=1;literal[i]!='"';i++){
        newLiteral[i-1]=literal[i];
    }
    newLiteral[i]='\0';
    return newLiteral;
}

#define YY_USER_ACTION yylloc.first_line = yylloc.last_line = yylineno; \
    yylloc.first_column = yycolumn; yylloc.last_column = yycolumn + yyleng - 1; \
    yycolumn += yyleng; \
    yylval.str = strdup(yytext);

%}
%option yylineno

%%

"return"                      {return T_RETURN;}
"if"                          {return T_IF;}
"else"                        {return T_ELSE;}
"while"                       {return T_WHILE;}
"print"                       {return T_PRINT;}
"read"                        {return T_READ;}

"void"                      {return T_VOID;}
"int"                       {return T_INTEGER;}
"string"                    {return T_STRING;}
"float"                     {return T_FLOAT;}

"("                         {return T_OPEN_PARENTHESES;}
")"                         {return T_CLOSE_PARENTHESES;}
"{"                         {return T_OPEN_BRACE;}
"}"                         {return T_CLOSE_BRACE;}

","                         {return T_COMMA;}
";"                         {return T_SEMICOLON;}
\"                          {return T_DOBLE_QUOTES;}

"!"                         {return T_NOT;}
"&&"                        {return T_AND;}
"||"                        {return T_OR;;}

"="                         {return T_ATRIBUITION;}
"+"                         {return T_PLUS;}
"-"                         {return T_MINUS;}
"*"                         {return T_MULTIPLY;}
"/"                         {return T_DIVIDE;}

"=="                        {return T_EQUALS;}
"!="                        {return T_DIFERENT;}
"<"                         {return T_LESS;}
">"                         {return T_MORE;}
"<="                        {return T_LESS_EQUALS;}
">="                        {return T_MORE_EQUALS;}


[A-Za-z_][A-Za-z0-9_]*      {/*yylval.indentifier = strdup(yytext);*/ return T_IDENTIFIER;}
[0-9]+    {yylval.integer = atoi(yytext); return T_NUMBER;}

\"[^\"]*\"                           {yylval.literal = removeQuotes(strdup(yytext)); return T_LITERAL;}
[ \t]
\n                          {yycolumn = 1;}
.


%%


void yyerror(char *s) {
    fprintf(stderr, "\nERRO NA LINHA %d : \n %s\n", yylineno, s);
    exit(0);
}

void TokenInvalido(){
    printf("ERRO NA LINHA %d : \n TOKEN INVALIDO %s\n", yylineno,yytext);
    exit(0);
}
