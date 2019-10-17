%option noyywrap

%{
#include <stdio.h>
#include <string.h>
#include <string.h>
#include "lang.tab.h"
void extern yyerror(char*);
void TokenInvalido();
%}


%%


"programa"                  {return T_PROGRAM;}
"var"                       {return T_VARIABLE;}
"inicio"                    {return T_START;}
"fim"                       {return T_END;}
"proc"                      {return T_PROCEDURE;}
"entao"                     {return T_THEN;}
"senao"                     {return T_ELSE;}
"enquanto"                  {return T_WHILE;}
"faca"                      {return T_DO;}
"div"                       {return T_DIVIDE;}
"mod"                       {return T_MODULE;}
"inteiro"                   {return T_TYPE;}
"se"                        {return T_IF;}
";"                         {return T_SEMICOLON;}
"."                         {return T_DOT;}
","                         {return T_COMMA;}
"("                         {return T_OPEN_PARENTHESES;}
")"                         {return T_CLOSE_PARENTHESES;}
":="                        {return T_ATRIBUITION;}
"="                         {return T_EQUALS;}
"<"                         {return T_LESS;}
">"                         {return T_MORE;}
"<>"                        {return T_DIFERENT;}
"<="                        {return T_LESS_EQUALS;}
">="                        {return T_MORE_EQUALS;}
"+"                         {return T_PLUS;}
"-"                         {return T_MINUS;}
"*"                         {return T_MULTIPLY;}
":"                         {return T_COLON;}

[A-Za-z_][A-Za-z0-9_]*      {yylval.indentifier = strdup(yytext); return T_IDENTIFIER;}
[0-9]+                      {yylval.number = atoi(yytext); return T_NUMBER;}

[ \t] ;
\n
.                           {TokenInvalido();}

%%


void yyerror(char *s) {
    fprintf(stderr, "\nERRO NA LINHA %d : \n %s\n", yylineno, s);
    exit(0);
}

void TokenInvalido(){
    printf("ERRO NA LINHA %d : \n TOKEN INVALIDO %s\n", yylineno,yytext);
    exit(0);
}