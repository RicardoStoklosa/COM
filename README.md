# COM
Projects from compilers lecture using flex and bison.

### T1
It is a little project to familiarize with the flex and bison.

### T2
This project has the purpose of creating a parser similar to c language. We use flex and bison to parse input code and generate a command list to be compiled in JVM utilizing Jasmin assembler.
To run the project use the Makefile.

Below there is a [code](T2/entrada) example that the parser waits for.

```c++
int factorial(int num){
    int i,f;
    i=1;
    f=1;
    while(i<=num){
        f=f*i;
        i=i+1;
    }
    return f;
}
{
    int b,c;
    string fac;
    fac = "fatorial de";
    read(c);
    b=factorial(c);
    print(fac);
    print(c);
    print("é igual a:");
    print(b);
    if(b>=25){
        print("maior que 25");
    }
    else{
        print("menor que 25");
    }
    return;
}
```
