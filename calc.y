%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int yylex();
int yyerror(char *s); 
%}

%union {
    int ival;
    float fval;
}

/* Declare tokens. */
%token<ival> INT_NUMBER
%token<fval> FLOAT_NUMBER
%token ADD SUB MUL DIV ABS LN LOG SIN COS TAN POW LEFT_P RIGHT_P EXIT EOL

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
 ;

i_term: INT_NUMBER
 | LEFT_P i_exp RIGHT_P { $$ = $2; }
 | i_term POW i_term    { $$ = pow($1, $3); }
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
 | i_factor DIV i_term { $$ = (float)$1 / $3; }
 ;

f_term: FLOAT_NUMBER
 | LEFT_P f_exp RIGHT_P { $$ = $2; }
 | LN f_term            { $$ = log($2); }
 | LN i_term            { $$ = log($2); }
 | LOG f_term           { $$ = log10($2); }
 | LOG i_exp            { $$ = log10($2); }
 | SIN f_exp            { $$ = sin($2); }
 | SIN i_exp            { $$ = sin($2); }
 | COS f_exp            { $$ = cos($2); }
 | COS i_exp            { $$ = cos($2); }
 | TAN f_exp            { $$ = tan($2); }
 | TAN i_exp            { $$ = tan($2); }
 | f_term POW f_term    { $$ = pow($1, $3); }
 | f_term POW i_term    { $$ = pow($1, $3); }
 | i_term POW f_term    { $$ = pow($1, $3); }
 | ABS f_term           { $$ = $2 >= 0? $2 : - $2; }
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
