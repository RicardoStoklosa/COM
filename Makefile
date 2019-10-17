all: lang

lang.tab.c lang.tab.h:	lang.y
	bison -d lang.y

lex.yy.c: lang.lex lang.tab.h
	flex lang.lex

lang: lex.yy.c lang.tab.c lang.tab.h
	g++ -o analizador lang.tab.c lex.yy.c

clean:
	rm analizador lang.tab.c lex.yy.c lang.tab.h