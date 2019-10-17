%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    extern int yylex();
    extern int yyparse();
    extern FILE* yyin;
    void yyerror(const char* s);
    
%}

%union {
    char* indentifier;
    int number;
}

%token<indentifier>    T_IDENTIFIER
%token<number>          T_NUMBER

%token
    T_PROGRAM
    T_SEMICOLON
    T_DOT
    T_VARIABLE
    T_COMMA
    T_START
    T_END
    T_PROCEDURE
    T_OPEN_PARENTHESES
    T_CLOSE_PARENTHESES
    T_IF
    T_ATRIBUITION
    T_THEN
    T_ELSE
    T_WHILE
    T_DO
    T_EQUALS
    T_LESS
    T_MORE
    T_DIFERENT
    T_LESS_EQUALS
    T_MORE_EQUALS
    T_PLUS
    T_MINUS
    T_MULTIPLY
    T_DIVIDE
    T_MODULE
    T_COLON
    T_TYPE

%%
PROG: T_PROGRAM T_IDENTIFIER T_SEMICOLON BLOCO T_DOT    {printf("%s",$2);}

BLOCO: T_VARIABLE T_IDENTIFIER T_COMMA T_IDENTIFIER T_COLON T_TYPE T_SEMICOLON
     | T_PROCEDURE T_IDENTIFIER PALIST T_SEMICOLON BLOCO T_SEMICOLON T_START
     | COMANDO T_SEMICOLON T
%%

int main() {
	yyin = stdin;

	do {
		yyparse();
	} while(!feof(yyin));

	return 0;
}

void yyerror(const char* s) {
    fprintf(stderr, "Parse error: %s\n", s);
    exit(1);
}