%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "symtable.c"
    #include "jasminGen.cpp"
    #define INT 0
    #define FLOAT 1
    #define STRING 2
    extern int yylex();
    extern int yyparse();
    extern FILE* yyin;
    void yyerror(const char* s);
    void yyerrorExpected(const char* recived, char* expected);
    int tmp=-1;

%}
%define parse.error verbose
%locations

%union {
    char* str;
    char* indentifier;
    int integer;
    float floatValue;
    char* literal;
    struct VALUE{
        int type;
        union{
            int intValue;
            float floatValue;
        };
        bool isResult;
    } value;
}

%token<indentifier>     T_IDENTIFIER
%token<str>     T_PLUS T_MINUS T_MULTIPLY T_DIVIDE
%token<value>         T_INTEGER_VALUE T_FLOAT_VALUE
%token<literal>         T_LITERAL
%type<integer> type cmdPrint
%type<str> operator
%type<value> arithmeticExpression
%type<str> idList
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
    T_FLOAT T_OPEN_PARENTHESES
    T_CLOSE_PARENTHESES
    T_OPEN_BRACE
    T_CLOSE_BRACE
    T_COMMA
    T_SEMICOLON
    T_NOT
    T_AND
    T_OR
    T_ATRIBUITION
    T_EQUALS
    T_DIFERENT
    T_LESS
    T_MORE
    T_LESS_EQUALS
    T_MORE_EQUALS
    T_DOBLE_QUOTES
%left T_PLUS T_MINUS
%left T_MULTIPLY T_DIVIDE

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

mainBlock:T_OPEN_BRACE {mainInit();} declarations cmdList T_CLOSE_BRACE {mainEnd();}
         |T_OPEN_BRACE {mainInit();} cmdList T_CLOSE_BRACE {mainEnd();}
         ;

declarations:declarations declare
            |declare
            ;

declare:type idList T_SEMICOLON {tmp=-1;}
       ;

type:T_INTEGER {tmp=INT;}
    |T_STRING {tmp=STRING;}
    |T_FLOAT {tmp=FLOAT;}
    ;

idList:idList T_COMMA T_IDENTIFIER {putSym($3,tmp);}
      |T_IDENTIFIER {putSym($1,tmp);}
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

return:T_RETURN arithmeticExpression T_SEMICOLON {output.push_back("\treturn");}
      |T_RETURN T_LITERAL T_SEMICOLON {output.push_back("\treturn");}
      |T_RETURN T_SEMICOLON {output.push_back("\treturn");}
      ;

cmdIf:T_IF T_OPEN_PARENTHESES logicExpression T_CLOSE_PARENTHESES block
     |T_IF T_OPEN_PARENTHESES logicExpression T_CLOSE_PARENTHESES block T_ELSE block
     ;

cmdWhile:T_WHILE T_OPEN_PARENTHESES logicExpression T_CLOSE_PARENTHESES block
        ;

cmdAtribuition:T_IDENTIFIER T_ATRIBUITION arithmeticExpression T_SEMICOLON
              |T_IDENTIFIER T_ATRIBUITION T_LITERAL T_SEMICOLON
              ;

cmdPrint:T_PRINT T_OPEN_PARENTHESES {printInit();} arithmeticExpression T_CLOSE_PARENTHESES T_SEMICOLON {printEnd($4.type);}
        |T_PRINT T_OPEN_PARENTHESES {printInit();} T_LITERAL T_CLOSE_PARENTHESES T_SEMICOLON {printEnd(STRING);}
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
arithmeticExpression:T_INTEGER_VALUE {$$=$1;cout<<$1.intValue<<"<==========="<<endl;}
                    |T_FLOAT_VALUE {$$=$1;cout<<$1.floatValue<<"<==========="<<endl;}
                    |arithmeticExpression T_PLUS arithmeticExpression
                    {
                        VALUE op1 = { $1.type, $1.intValue, $1.isResult };
                        if($1.type==FLOAT)
                            op1.floatValue=$1.floatValue;
                        VALUE op2 = { $3.type, $3.intValue, $3.isResult };
                        if($3.type==FLOAT)
                            op2.floatValue=$3.floatValue;
                        $$.type=calc(op1,$2,op2);
                        $$.isResult=true;

                    }
logicExpression:
               ;

%%

int main(int argc,char* argv[]) {
    initFile();
    argc--;argv++;
    if ( argc > 0 )
        yyin = fopen( argv[0], "r" );
    else
        yyin = stdin;

    do {
        yyparse();
    } while(!feof(yyin));
    printf("Nenhum erro encontrado\n");
    showSymTable();
    for(string str:output){
        cout<<str<<endl;
    }
    writeFile();

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
void yyerrorExpected(const char* recived, char* expected) {
    fprintf(stderr, "ERRO EM [%d:%d]: \n",yylloc.first_line, yylloc.first_column);
    fprintf(stderr, "Esperava %s recebeu %s\n",expected,recived);
    exit(1);
}

