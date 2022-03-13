calc: calc.l calc.y
	bison -d calc.y
	flex calc.l
	gcc -o $@ calc.tab.c lex.yy.c -lfl -lm

clean:
	rm -f calc calc.tab* lex.yy.c
