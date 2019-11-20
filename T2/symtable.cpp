#include<iostream>
#include<vector>
#include <string.h>
#define INT 0
#define FLOAT 1
#define STRING 2
#define VAR 3
#define FUNC 4

using namespace std;

struct var{
    string name;
    int type;
    int local;
};
struct func{
    string name;
    vector<var> variables;
};
vector<pair<int,vector<var>>>symtable;

//void putSym(string nome, int type);
//void putFunc(string nome);
/*
symrec *getSym(char* nome);
char* getType(int type);
void showSymTable();
int areadyExists(char* nome);
*/
//void putSym(string symName, int type, string funcName){
   /* if( areadyExists(sym_name) ){
        printf("A variavel \"%s\" ja existe\n",sym_name);
        exit(1);
    }
*/
    
//    return;
//}
//void putFunc(string funcName){
   /* if( areadyExists(sym_name) ){
        printf("A variavel \"%s\" ja existe\n",sym_name);
        exit(1);
    }
*/
//    sym_table.push_back({funcName});
//    return;
//}
/*
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
*/