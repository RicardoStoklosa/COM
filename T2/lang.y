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
    float number;
}

%token<indentifier>    T_IDENTIFIER
%token<number>          T_NUMBER
%start program
%token
    T_RETURN
    T_IF
    T_ELSE
    T_WHILE
    T_PRINT
    T_READ
    T_VOID
    T_INTEGER
    T_STRING
    T_FLOAT
    T_OPEN_PARENTHESES
    T_CLOSE_PARENTHESES
    T_OPEN_BRACE
    T_CLOSE_BRACE
    T_COMMA
    T_SEMICOLON
    T_NOT
    T_AND
    T_OR
    T_ATRIBUITION
    T_PLUS
    T_MINUS
    T_MULTIPLY
    T_DIVIDE
    T_EQUALS
    T_DIFERENT
    T_LESS
    T_MORE
    T_LESS_EQUALS
    T_MORE_EQUALS
    T_LITERAL

%%

program:functionList mainBlock
         |mainBlock
         ;

functionList:functionList function
            |function
            ;

function:returnType T_IDENTIFIER T_OPEN_PARENTHESES declareParams T_CLOSE_PARENTHESES mainBlock
        |returnType T_IDENTIFIER T_OPEN_PARENTHESES T_CLOSE_PARENTHESES mainBlock
        ;

returnType:type
          |T_VOID
          ;

declareParams:declareParams T_COMMA param
             |param
             ;

param:type T_IDENTIFIER
     ;

mainBlock:T_OPEN_BRACE declarations cmdList T_CLOSE_BRACE
         |T_OPEN_BRACE cmdList T_CLOSE_BRACE
         ;

declarations:declarations declare
            |declare
            ;

declare:type idList
       ;

type:T_INTEGER
    |T_STRING
    |T_FLOAT
    ;

idList:idList T_COMMA T_IDENTIFIER
      |T_IDENTIFIER
      ;

block:T_OPEN_BRACE cmdList T_CLOSE_BRACE
     ;

cmdList:cmdList command
       |command
       ;

command:cmdIf
       |cmdWhile
       |cmdAtribuition
       |cmdPrint
       |cmdRead
       |procCall
       |return
       ;

return:T_RETURN arithmeticExpression T_SEMICOLON
      |T_LITERAL;

cmdIf:T_IF T_OPEN_PARENTHESES logicExpression T_CLOSE_PARENTHESES block
     |T_IF T_OPEN_PARENTHESES logicExpression T_CLOSE_PARENTHESES block T_ELSE block
     ;

cmdWhile:T_WHILE T_OPEN_PARENTHESES logicExpression T_CLOSE_PARENTHESES block
        ;

cmdAtribuition:T_IDENTIFIER T_ATRIBUITION logicExpression T_SEMICOLON
              |T_IDENTIFIER T_ATRIBUITION T_LITERAL
              ;

cmdPrint:T_PRINT T_OPEN_PARENTHESES logicExpression T_CLOSE_PARENTHESES T_SEMICOLON
        |T_PRINT T_OPEN_PARENTHESES T_LITERAL T_CLOSE_PARENTHESES
        ;

cmdRead:T_READ T_OPEN_PARENTHESES T_IDENTIFIER T_CLOSE_PARENTHESES T_SEMICOLON
       ;

procCall:functionCall T_SEMICOLON
        ;

functionCall:T_IDENTIFIER T_OPEN_PARENTHESES paramList T_CLOSE_PARENTHESES
            |T_IDENTIFIER T_OPEN_PARENTHESES T_CLOSE_PARENTHESES
            ;

paramList:paramList T_COMMA arithmeticExpression
         |paramList T_COMMA T_LITERAL
         |arithmeticExpression
         |T_LITERAL
         ;

arithmeticExpression:
                    ;

logicExpression:
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
