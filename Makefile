parser: y.tab.c lex.yy.c
	gcc -o parser y.tab.c lex.yy.c
y.tab.c: .yacc lex.yy.c
	yacc -d CS315_F23_Team22.yacc
lex.yy.c: CS315_F23_Team22.lex
	lex CS315_F23_Team22.lex
clean:
	rm -f lex.yy.c y.tab.c parser
