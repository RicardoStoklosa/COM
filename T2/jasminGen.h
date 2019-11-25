#include<iostream>
#include<string>
#include<vector>
#include<iterator>
#include<fstream>
#define INT 0
#define FLOAT 1
#define STRING 2
#define VOID 3

using namespace std;
struct VALUE{
    int type;
    union{
        int intValue;
        float floatValue;
    };
    bool isResult;
};

struct sym{
    int type;
    union{
        int intVal;
        float floatVal;
        char* name;
    };
};
vector<string> output;
vector<string>::iterator itTmp;

void initFile();
void writeFile();

void mainInit();
void mainEnd();

void printInit();
void printEnd(int type);

int calc(VALUE op1,char* op,VALUE op2);

void pen(string str);

void go_to(char to, int num);
void labelGen(char to, int num);
