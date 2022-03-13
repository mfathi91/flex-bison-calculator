%{
# include "calc.tab.h"
%}

%%

"+"            { return ADD; }
"-"            { return SUB; }
"*"            { return MUL; }
"/"            { return DIV; }
"("            { return LEFT_P; }
")"            { return RIGHT_P; }
"|"            { return ABS; }
[0-9]+         { yylval.ival = atoi(yytext); return INT_NUMBER; }
[0-9]+\.[0-9]+ { yylval.fval = atof(yytext); return FLOAT_NUMBER; }
\n             { return EOL; }
[ \t]          { /* ignore whitespace */ }
exit|quit      { return EXIT; }
.              { printf("Mystery character %c\n", *yytext); }

%%
