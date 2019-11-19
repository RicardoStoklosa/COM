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

void sum(sym op1,sym op2){
}
