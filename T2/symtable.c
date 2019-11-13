#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define INT 0
#define FLOAT 1
#define STRING 2

struct symrec{
    char *name;
    int type;
    union{
        int intValue;
        float floatValue;
        char *charValue;
    };
    struct symrec *next;
};


typedef struct symrec symrec;
symrec *sym_table = (symrec *)0;
symrec *putSym(char* nome, int type);
symrec *getSym(char* nome);
void setValueInt(char* nome, int value);
void setValueFloat(char* nome, float value);
void setValueString(char* nome, char* value);
char* getType(int type);
void showSymTable();
int areadyExists(char* nome);

symrec* putSym(char *sym_name, int type){
    if( areadyExists(sym_name) ){
        printf("A variavel \"%s\" ja existe\n",sym_name);
        exit(1);
    }

    symrec*ptr;
    ptr = (symrec*)malloc(sizeof(symrec));
    ptr->name=(char*)malloc(strlen(sym_name)+1);
    strcpy(ptr->name,sym_name);
    ptr->type = type;
    if( type==INT ){
        ptr->intValue = 0;
    }
    else if( type==FLOAT ){
        ptr->floatValue = 0.0f;
    }
    else if( type==STRING ){
        ptr->charValue=(char*)malloc(3*sizeof(char));
        strcpy(ptr->charValue,"oi");
    }

    ptr->next=(struct symrec*)sym_table;
    sym_table=ptr;
    return ptr;
}

symrec* getSym(char *sym_name){
    symrec *ptr;
    for( ptr=sym_table; ptr!=(symrec*)0; ptr=(symrec*)ptr->next )
        if(strcmp(ptr->name,sym_name)==0)
            return ptr;
    return 0;
}
void showSymTable(){
    symrec *ptr;
    printf("\ntabela de simbolos\n");
    printf("==================\n");
    for( ptr=sym_table; ptr!=(symrec*)0; ptr=(symrec*)ptr->next ){
        printf("{%s:%s}=",ptr->name,getType(ptr->type));
        if(ptr->type == INT)
            printf("%d\n",ptr->intValue);
        else if(ptr->type == FLOAT)
            printf("%f\n",ptr->floatValue);
        else if(ptr->type == STRING)
            printf("%s\n",ptr->charValue);
    }
    printf("\n==================\n");
}

void setValueInt(char* nome, int value){
    symrec* ptr = getSym(nome);
    if( ptr==0 ){
        printf("A variavel %s nao exixte ", nome);
        exit(1);
    }
    if( ptr->type!=INT ){
        fprintf(stderr, "Esperava \"int\" recebeu \"%s\"\n",getType(ptr->type));
        exit(1);
        /*yyerrorExpected("inteiro",getType(ptr->type));*/
        return;
    }
    ptr->intValue = value;
}
void setValueFloat(char* nome, float value){
    symrec* ptr = getSym(nome);
    if( ptr==0 ){
        printf("A variavel %s nao exixte ", nome);
        exit(1);
    }
    if( ptr->type!=FLOAT ){
        fprintf(stderr, "Esperava \"float\" recebeu \"%s\"\n",getType(ptr->type));
        exit(1);
        /*yyerrorExpected("float",getType(ptr->type));*/
    }
    ptr->floatValue = value;
}

void setValueString(char* nome, char* value){
    symrec* ptr = getSym(nome);
    if( ptr==0 ){
        printf("A variavel %s nao exixte ", nome);
        exit(1);
    }
    if( ptr->type!=STRING ){
        fprintf(stderr, "Esperava \"string\" recebeu \"%s\"\n",getType(ptr->type));
        exit(1);
        /*yyerrorExpected("string",getType(ptr->type));*/
    }
    strcpy(ptr->charValue,value);
}

char* getType(int type){
    char *res;
    res=(char*)malloc(7*sizeof(char));
    if(type == INT)
        strcpy(res,"int");
    else if(type == FLOAT)
        strcpy(res,"float");
    else if(type == STRING)
        strcpy(res,"string");
    return res;
}

int areadyExists(char* nome){
    symrec* ptr = getSym(nome);
    if( ptr==0 ){
        return 0;
    }
    return 1;
}
