#include<iostream>
#include<string>
#include<vector>
#include<fstream>
#define INT 0
#define FLOAT 1
#define STRING 2
#define VAR 3

using namespace std;

struct sym{
    int type;
    union{
        int intVal;
        float floatVal;
        char* name;
    };
};
vector<string> output;

void initFile();
void writeFile();

void mainInit();
void mainEnd();

void printInit();
void printEnd(int type);

void sum(sym op1,sym op2);

