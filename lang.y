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
prog: T_PROGRAM T_IDENTIFIER T_SEMICOLON bloco T_DOT    {printf("%s",$2);}
    ;

bloco: var
     | procedure
     | command_end
     ;

var: /* EPSILON */
    | T_VARIABLE ident var
    ;

ident: T_IDENTIFIER comma_ident T_COLON T_TYPE T_SEMICOLON
     | T_IDENTIFIER comma_ident T_COLON T_TYPE T_SEMICOLON ident
     ;

comma_ident: /* EPSILON */
           | T_COMMA T_IDENTIFIER comma_ident
           ;

procedure:/* EPSILON */
         | T_PROCEDURE T_IDENTIFIER palist T_SEMICOLON bloco T_SEMICOLON procedure T_START
         ;

command_end: command_semicolon T_SEMICOLON T_END command_end_epsilon
           | command_semicolon T_END command_end_epsilon
           ;

command_end_epsilon:
                   | command_semicolon T_SEMICOLON T_END command_semicolon_epsilon
                   | command_semicolon T_END command_semicolon_epsilon
                   ;

command_semicolon: command T_SEMICOLON command_semicolon_epsilon
                 ;

command_semicolon_epsilon:
                         | command T_SEMICOLON command_semicolon_epsilon
                         ;

palist:/* EPSILON */
      | T_OPEN_PARENTHESES var_palist T_CLOSE_PARENTHESES
      ;

var_palist: T_VARIABLE ident_comma T_COLON T_TYPE T_SEMICOLON var_parlist_epsilon
          | ident_comma T_COLON T_TYPE T_SEMICOLON var_parlist_epsilon
          ;

var_parlist_epsilon:
                   | T_VARIABLE ident_comma T_COLON T_TYPE T_SEMICOLON var_parlist_epsilon
                   | ident_comma T_COLON T_TYPE T_SEMICOLON var_parlist_epsilon
                     ;

ident_comma: T_IDENTIFIER T_COMMA ident_comma
           ;

command: T_VARIABLE T_ATRIBUITION expr
       | proc
       | T_IF expr T_THEN command T_ELSE command
       | T_IF expr T_THEN command
       | T_WHILE expr T_DO command
       | T_START command_semicolon T_END
       ;

proc: T_PROCEDURE T_OPEN_PARENTHESES expr_comma T_CLOSE_PARENTHESES
    | T_PROCEDURE
    ;

expr_comma: expr T_COMMA expr_comma
          ;

expr: siexpr
    | siexpr compare siexpr
    ;

compare: T_EQUALS
       | T_LESS
       | T_MORE
       | T_DIFERENT
       | T_LESS_EQUALS
       | T_MORE_EQUALS
       ;

siexpr: T_PLUS term_symbol
      | T_MINUS term_symbol
      ;

term_symbol: term T_PLUS term_symbol
           | term T_MINUS term_symbol
           ;

term: factor T_MULTIPLY term
    | factor T_DIVIDE term
    | factor T_MODULE term
    ;

factor: T_NUMBER
      | T_IDENTIFIER
      | T_OPEN_PARENTHESES expr T_CLOSE_PARENTHESES
      ;

%%

int main() {
	yyin = stdin;

	do {
        char line[256];
        fgets(line, sizeof(line), yyin);
        fprintf(stderr, "%s",line);
		yyparse();
	} while(!feof(yyin));

	return 0;
}

void yyerror(const char* s) {
    /*char line[256];*/
    /*fgets(line, sizeof(line), yyin);*/
    /*fprintf(stderr, "%s",line);*/
    fprintf(stderr, "ERRO EM [%d:%d]: %s\n",yylloc.first_line, yylloc.first_column, yylval.str);
    fprintf(stderr, "%s",s);
    exit(1);
}
