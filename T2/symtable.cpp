#include<iostream>
#include<vector>
#include <string.h>
#define INT 0
#define FLOAT 1
#define STRING 2
#define VAR 3
#define FUNC 4

using namespace std;

struct func{
    string name;
    vector<int> atrr;

};

typedef struct symrec symrec;
symrec *sym_table = (symrec *)0;
symrec *putSym(char* nome, int type);
symrec *getSym(char* nome);
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
        printf("{%s:%s}\n",ptr->name,getType(ptr->type));
    }
    printf("\n==================\n");
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
