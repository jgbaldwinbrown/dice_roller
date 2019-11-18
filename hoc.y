%{
#define YYSTYPE double /* data type of yacc stack */
# include "hoc1h.h"
# include <stdio.h>
# include <ctype.h>
# include <math.h>
# include <stdlib.h>
%}
%token NUMBER
%left 'q'
%left '+' '-' /* left associative, same precedence */
%left '*' '/' /* left assoc., higher precedence */
%right '^' /* right assoc., higher precedence */
%left UNARYMINUS /* new */
%%
list: /* nothing */
    | list '\n'
    | list expr '\n' { printf("\t%.8g\n", $2); }
    ;
expr: NUMBER { $$ = $1; }
    | '-' expr %prec UNARYMINUS { $$ = -$2; }
    | expr '+' expr { $$ = $1 + $3; }
    | expr '-' expr { $$ = $1 - $3; }
    | expr '*' expr { $$ = $1 * $3; }
    | expr '/' expr { $$ = $1 / $3; }
    | expr '^' expr { $$ = pow($1, $3); }
    | '(' expr ')' { $$ = $2; }
    | 'q' { exit(0); }
    ;
%%
    /* end of grammar */

char *progname;
int lineno = 1;

int main(int argc, char *argv[]) {
    progname = argv[0];
    yyparse();
    return(0);
}

int yylex() {
    int c;
    while ((c=getchar()) == ' ' || c == '\t')
        ;
    if (c == EOF)
        return 0;
    if (c == '.' || isdigit(c)) { /* number */
        ungetc(c, stdin);
        scanf("%lf", &yylval);
        return NUMBER;
    }
    if (c == '\n')
        lineno++;
    return(c);
}

void yyerror(char *s) {
    warning(s, (char *) 0);
}

void warning(char *s, char *t) {
    fprintf(stderr, "%s: %s", progname, s);
    if (t)
        fprintf(stderr, " %s", t);
    fprintf(stderr, " near line %d\n", lineno);
}
