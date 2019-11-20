#include"jasminGen.h"
#include<fstream>


void initFile(){
    output.push_back(".class public output");
    output.push_back(".super java/lang/Object");

    output.push_back(".method public <init>()V");
    output.push_back("\taload_0");

    output.push_back("\tinvokenonvirtual java/lang/Object/<init>()V");
    output.push_back("\treturn");
    output.push_back(".end method");
}

void mainInit(){
    output.push_back(".method public static main([Ljava/lang/String;)V");
    output.push_back("\t.limit stack 5");
    output.push_back("\t.limit locals 4");
}

void mainEnd(){
    output.push_back(".end method");
}

void printInit(){
	output.push_back("\tgetstatic java/lang/System/out Ljava/io/PrintStream;");
}

void printEnd(int type){
    if(type==STRING)
        output.push_back("\tinvokevirtual java/io/PrintStream/println(Ljava/lang/String;)V");
    else if(type==INT)
        output.push_back("\tinvokevirtual java/io/PrintStream/println(I)V");
    else if(type==FLOAT)
        output.push_back("\tinvokevirtual java/io/PrintStream/println(F)V");
}

void writeFile(){
    ofstream outFile ("output.jout");
    for(string line:output){
        outFile << line << "\n";
    }
}

int calc(VALUE op1,char* op, VALUE op2){
    int res =-1;
    string aux;
    cout<<"RE="<<op1.isResult<<endl;
    if(op1.type==FLOAT || op2.type==FLOAT){
        res=1;
        aux="\tf";
        if(!op1.isResult){
            if(op1.type==INT)
                output.push_back("\tldc "+to_string((float)op1.intValue));
            else
                output.push_back("\tldc "+to_string(op1.floatValue));
        }
        if(!op2.isResult){
            if(op2.type==INT)
                output.push_back("\tldc "+to_string((float)op2.intValue));
            else
                output.push_back("\tldc "+to_string(op2.floatValue));
        }

    }
    else{
        res=0;
        aux="\ti";

        if(!op1.isResult){
            output.push_back("\tldc "+to_string(op1.intValue));
        }
        if(!op2.isResult){
            output.push_back("\tldc "+to_string(op2.intValue));
        }
    }
    aux.append(op);
    output.push_back(aux);
    return res;
}

void store(string name){
    var v = getSym(name);
    if(v.type==STRING)
        output.push_back("\tastore "+to_string(v.local));
    else if(v.type==INT)
        output.push_back("\tfstore "+to_string(v.local));
    else if(v.type==FLOAT)
        output.push_back("\tfstore "+to_string(v.local));
}

void load(string name){
    var v = getSym(name);
    if(v.type==STRING)
        output.push_back("\taload "+to_string(v.local));
    else if(v.type==INT)
        output.push_back("\tfload "+to_string(v.local));
    else if(v.type==FLOAT)
        output.push_back("\tfload "+to_string(v.local));
}
