%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
%}

/* declare tokens */
%token NUMBER
%token ADD SUB MUL DIV ABS
%token LEFT_P RIGHT_P
%token EXIT EOL

%%

calclist: /* nothing */
 | calclist exp EOL  { printf("= %d\n", $2); }
 | calclist EXIT EOL { exit(0); }
 ;

exp: factor
 | exp ADD factor { $$ = $1 + $3; }
 | exp SUB factor { $$ = $1 - $3; }
 ;

factor: term
 | factor MUL term { $$ = $1 * $3; }
 | factor DIV term { $$ = $1 / $3; }
 ;

term: elem
 | LEFT_P exp RIGHT_P { $$ = $2; }

elem: NUMBER
 | ABS elem { $$ = $2 >= 0? $2 : - $2; }
 ;

%%

int main(int argc, char **argv) {
    yyparse();
    return 0;
}

int yyerror(char *s) {
    fprintf(stderr, "Error: %s\n", s);
    return -1;
}
