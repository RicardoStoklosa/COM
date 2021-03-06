%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include<vector>
    #include "symtable.cpp"
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
    char label ='A';

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
    char c;
    int contparam=0;
}

%token<indentifier>     T_IDENTIFIER
%token<str>     T_PLUS T_MINUS T_MULTIPLY T_DIVIDE
%token<value>         T_INTEGER_VALUE T_FLOAT_VALUE
%token<literal>         T_LITERAL
%type<integer> type cmdPrint returnType
%type<integer> arithmeticExpression
%type<contparam> paramList
%type<str> idList
%type<c> whileIf
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
%token T_EQUALS T_DIFERENT
 T_LESS T_MORE
 T_LESS_EQUALS T_MORE_EQUALS
%token  T_DOBLE_QUOTES
%left T_PLUS T_MINUS
%left T_MULTIPLY T_DIVIDE
%right MIN


%start program
%%

program:functionList mainBlock
       |mainBlock
       ;

functionList:functionList function { cleanSymTable(); }
            |function { cleanSymTable(); }
            ;

function:returnType T_IDENTIFIER T_OPEN_PARENTHESES declareParams T_CLOSE_PARENTHESES {
        func($1,$2,symtable.size());
        } funcBlock { mainEnd();showSymTable();itTmp->append(to_string(symtable.size()+1));}
        |returnType T_IDENTIFIER T_OPEN_PARENTHESES {
        func($1,$2,symtable.size());
        } T_CLOSE_PARENTHESES funcBlock { mainEnd();showSymTable();itTmp->append(to_string(symtable.size()+1));}
        ;


funcBlock:T_OPEN_BRACE declarations cmdList T_CLOSE_BRACE
         |T_OPEN_BRACE cmdList T_CLOSE_BRACE
         ;

returnType:type {$$=tmp;}
          |T_VOID {$$=4;}
          ;

declareParams:declareParams T_COMMA param
             |param
             ;

param:type T_IDENTIFIER { putSym($2,tmp); }
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

return:T_RETURN arithmeticExpression T_SEMICOLON {output.push_back("\tireturn");}
      |T_RETURN T_LITERAL T_SEMICOLON {output.push_back("\treturn");}
      |T_RETURN T_SEMICOLON {output.push_back("\treturn");}
      ;

cmdIf:iflabel T_OPEN_PARENTHESES logicExpression ifT block { labelGen(label,2); }
     |iflabel T_OPEN_PARENTHESES logicExpression ifT endelseblock elset block { labelGen(label,3); }
     ;

iflabel:T_IF { label++; }
       ;

elset:T_ELSE { labelGen(label,2); }
     ;

ifT:T_CLOSE_PARENTHESES {  go_to(label,2); labelGen(label,1); }
    ;

endelseblock: block { go_to(label,3); }
            ;

cmdWhile:T_WHILE whileIf logicExpression whileT block { go_to($2,2); labelGen($2,3); }
        ;

whileT:T_CLOSE_PARENTHESES { go_to(label,3); labelGen(label,1); }
    ;
whileIf:T_OPEN_PARENTHESES { $$=label;labelGen(label,2); }
       ;
cmdAtribuition:T_IDENTIFIER T_ATRIBUITION arithmeticExpression T_SEMICOLON {store($1);}
              |T_IDENTIFIER T_ATRIBUITION T_LITERAL T_SEMICOLON {string str = $3;output.push_back("\tldc \""+str+"\""); store($1);}
              |T_IDENTIFIER T_ATRIBUITION functionCall T_SEMICOLON {store($1);}
              ;

cmdPrint:T_PRINT T_OPEN_PARENTHESES {printInit();} arithmeticExpression T_CLOSE_PARENTHESES T_SEMICOLON {printf("==>%d\n",$4);printEnd($4);}
        |T_PRINT T_OPEN_PARENTHESES {printInit();} T_LITERAL T_CLOSE_PARENTHESES T_SEMICOLON { literalLoad($4); printEnd(STRING);}
        ;

cmdRead:T_READ T_OPEN_PARENTHESES T_IDENTIFIER T_CLOSE_PARENTHESES T_SEMICOLON { var v =getSym($3);
                                                                                 read(v.type);
                                                                                 store(v.name);
                                                                               }
       ;

procCall:functionCall T_SEMICOLON
        ;

functionCall:T_IDENTIFIER T_OPEN_PARENTHESES paramList T_CLOSE_PARENTHESES {
            funcCall($1,$3);
            }
            |T_IDENTIFIER T_OPEN_PARENTHESES T_CLOSE_PARENTHESES
            ;

paramList:paramList T_COMMA arithmeticExpression { $$++; }
         |paramList T_COMMA T_LITERAL { $$++; }
         |arithmeticExpression { $$++; }
         |T_LITERAL { $$++; }
         ;

arithmeticExpression: T_INTEGER_VALUE { output.push_back("\tldc "+to_string($1.intValue)); }
    | arithmeticExpression T_PLUS arithmeticExpression  { output.push_back("\tiadd"); }
    | arithmeticExpression T_MINUS arithmeticExpression     { output.push_back("\tisub"); }
    | arithmeticExpression T_MULTIPLY arithmeticExpression { output.push_back("\timul"); }
    | arithmeticExpression T_DIVIDE arithmeticExpression { output.push_back("\tidiv"); }
    | T_OPEN_PARENTHESES arithmeticExpression T_CLOSE_PARENTHESES {}
    | T_IDENTIFIER {
        string str=$1;
        load(str);
        var v = getSym(str);
        $$=v.type;
        }
    ;

logicExpression:arithmeticExpression T_LESS arithmeticExpression { compar("lt",label); }
               |arithmeticExpression T_LESS_EQUALS arithmeticExpression { compar("le",label); }
               |arithmeticExpression T_MORE arithmeticExpression { compar("gt",label); }
               |arithmeticExpression T_MORE_EQUALS arithmeticExpression { compar("ge",label); }
               |arithmeticExpression T_EQUALS arithmeticExpression { compar("eq",label); }
               |arithmeticExpression T_DIFERENT arithmeticExpression { compar("ne",label); }
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
    /*
    for(string str:output){
        cout<<str<<endl;
    }*/
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

