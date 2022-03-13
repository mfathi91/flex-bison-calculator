%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
%}

%union {
    int ival;
    float fval;
}

/* Declare tokens. */
%token<ival> INT_NUMBER
%token<fval> FLOAT_NUMBER
%token ADD SUB MUL DIV ABS LEFT_P RIGHT_P EXIT EOL

/* Declare types. */
%type<ival> i_exp i_factor i_term
%type<fval> f_exp f_factor f_term

%%

calclist: /* nothing */
 | calclist i_exp EOL { printf("= %d\n", $2); }
 | calclist f_exp EOL { printf("= %.2f\n", $2); }
 | calclist EXIT EOL  { exit(0); }
 ;

/* Integer operations. */
i_exp: i_factor
 | i_exp ADD i_factor { $$ = $1 + $3; }
 | i_exp SUB i_factor { $$ = $1 - $3; }
 ;

i_factor: i_term
 | i_factor MUL i_term { $$ = $1 * $3; }
 | i_factor DIV i_term { $$ = $1 / $3; }
 ;

i_term: INT_NUMBER
 | LEFT_P i_exp RIGHT_P { $$ = $2; }
 | ABS i_term           { $$ = $2 >= 0? $2 : - $2; }
 ;

/* Float operations. */
f_exp: f_factor
 | f_exp ADD f_factor { $$ = $1 + $3; }
 | f_exp ADD i_factor { $$ = $1 + $3; }
 | i_exp ADD f_factor { $$ = $1 + $3; }
 | f_exp SUB f_factor { $$ = $1 - $3; }
 | f_exp SUB i_factor { $$ = $1 - $3; }
 | i_exp SUB f_factor { $$ = $1 - $3; }
 ;

f_factor: f_term
 | f_factor MUL f_term { $$ = $1 * $3; }
 | f_factor MUL i_term { $$ = $1 * $3; }
 | i_factor MUL f_term { $$ = $1 * $3; }
 | f_factor DIV f_term { $$ = $1 / $3; }
 | f_factor DIV i_term { $$ = $1 / $3; }
 | i_factor DIV f_term { $$ = $1 / $3; }
 ;

f_term: FLOAT_NUMBER
 | LEFT_P f_exp RIGHT_P { $$ = $2; }
 | ABS f_term { $$ = $2 >= 0? $2 : - $2; }
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
