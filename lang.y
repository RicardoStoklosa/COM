%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    extern int yylex();
    extern int yyparse();
    extern FILE* yyin;
    void yyerror(const char* s);

%}
%define parse.error verbose
%locations

%union {
    char* str;
    char* indentifier;
    int number;
}

%token<indentifier>    T_IDENTIFIER
%token<number>          T_NUMBER
%start prog
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
prog: T_PROGRAM T_IDENTIFIER T_SEMICOLON bloco T_DOT
    ;

bloco: bloco2 bloco5 T_START comando T_SEMICOLON bloco6 bloco7 T_END
     ;

bloco2:
      | T_VARIABLE T_IDENTIFIER bloco4 T_COLON T_TYPE T_SEMICOLON bloco3 bloco2
      ;

bloco3:
      | T_IDENTIFIER bloco4 T_COLON T_TYPE T_SEMICOLON bloco3
      ;

bloco4:
      | T_COMMA T_IDENTIFIER bloco4
      ;

bloco5:
      | T_PROCEDURE T_IDENTIFIER palist T_SEMICOLON bloco T_SEMICOLON bloco5
      ;

bloco6:
      | comando T_SEMICOLON bloco6
      ;

bloco7:
      | T_SEMICOLON
      ;

palist:
      | T_OPEN_PARENTHESES palist3 T_IDENTIFIER T_COMMA palist4 T_COLON T_TYPE T_SEMICOLON palist2 T_CLOSE_PARENTHESES
      ;

palist2:
       | palist3 T_IDENTIFIER T_COMMA palist4 T_COLON T_TYPE T_SEMICOLON palist2
       ;

palist3:
       | T_VARIABLE
       ;

palist4:
       | T_IDENTIFIER T_COMMA palist4
       ;

comando: T_IDENTIFIER T_ATRIBUITION expr
       | T_PROCEDURE comando2
       | T_IF expr T_THEN comando comando4
       | T_WHILE expr T_DO comando
       | T_START comando comando5 T_END
       ;

comando2: 
        | T_OPEN_PARENTHESES expr T_COMMA comando3 T_CLOSE_PARENTHESES
        ;

comando3:
        | expr T_COMMA comando3
        ;
    
comando4:
        | T_ELSE comando
        ;

comando5:
        | T_SEMICOLON comando comando5
        ;

expr: siexpr expr2
    ;

expr2:
     | T_LESS siexpr
     | T_MORE siexpr
     | T_DIFERENT siexpr
     | T_LESS_EQUALS siexpr
     | T_MORE_EQUALS siexpr
     ;

siexpr: siexpr2 termo siexpr3
      ;

siexpr2:
       | T_PLUS
       | T_MINUS
       ;

siexpr3:
       | operador2 termo siexpr3
       ;

operador2: T_PLUS
         | T_MINUS
         ;

termo: fator termo2
     ;

termo2:
      | operador fator termo2
      ;

operador: T_MULTIPLY
        | T_DIVIDE
        | T_MODULE
        ;

fator: T_NUMBER
     | T_IDENTIFIER
     | T_OPEN_PARENTHESES expr T_CLOSE_PARENTHESES
     ;

%%

int main() {
	yyin = stdin;

	do {
		yyparse();
	} while(!feof(yyin));

	return 0;
}

void yyerror(const char* s) {
    /*char line[256];*/
    /*fgets(line, sizeof(line), yyin);*/
    /*fprintf(stderr, "%s",line);*/
    fprintf(stderr, "ERRO EM [%d:%d]: %s\n",yylloc.first_line, yylloc.first_column, yylval.str);
    fprintf(stderr, "%s\n",s);
    exit(1);
}
