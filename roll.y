%{
#define YYSTYPE double /* data type of yacc stack */
# include "roll.h"
# include <stdio.h>
# include <ctype.h>
# include <math.h>
# include <stdlib.h>
# include <time.h>
# include <gsl/gsl_rng.h>
# include <stdbool.h>
#include <string.h>

/* globals */
gsl_rng *rng;
bool print_rolls;
/* end globals */
%}
%token NUMBER
%left 'q'
%left '+' '-' /* left associative, same precedence */
%left '*' '/' /* left assoc., higher precedence */
%right '^' /* right assoc., higher precedence */
%left UNARYMINUS /* new */
%left 'd' /*die roll*/
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
    | expr 'd' expr { $$ = conditional_print_roll($1, $3, rng, print_rolls); }
    | expr 'D' expr 'M' expr { $$ = conditional_print_roll_minmax($1, $3, rng, print_rolls, MAX, $5); }
    | expr 'D' expr 'm' expr { $$ = conditional_print_roll_minmax($1, $3, rng, print_rolls, MIN, $5); }
    | '(' expr ')' { $$ = $2; }
    | 'q' { exit(0); }
    | 'p' { print_rolls = !print_rolls; $$ = 0; }
    ;
%%
    /* end of grammar */

char *progname;
int lineno = 1;

int main(int argc, char *argv[]) {
    rng = gsl_rng_alloc(gsl_rng_taus);
    gsl_rng_set(rng, time(0));
    
    progname = argv[0];
    
    yyparse();
    
    gsl_rng_free(rng);
    return(0);
}

long long uniform_distribution(long long rangeLow, long long rangeHigh, gsl_rng *rng) {
    long long out = ((long long) gsl_rng_uniform_int(rng, (rangeHigh-rangeLow) + 1)) + rangeLow;
    return(out);
}

double roll(double ndice, double dicesize, gsl_rng *rng) {
    long long ndice_i = (int) ndice;
    long long dicesize_i = (int) dicesize;
    long long sum = 0;
    for (size_t i=0; i<ndice_i; i++) {
        sum += uniform_distribution(1, dicesize_i, rng);
    }
    return((double) sum);
}

double conditional_print_roll(double ndice, double dicesize, gsl_rng *rng, bool print_rolls) {
    long long ndice_i = (int) ndice;
    long long dicesize_i = (int) dicesize;
    long long sum = 0;
    long long aroll = 0;
    for (size_t i=0; i<ndice_i; i++) {
        aroll = uniform_distribution(1, dicesize_i, rng);
        if (print_rolls) {
            printf("%lld\n", aroll);
        }
        sum += aroll;
    }
    return((double) sum);
}

int compare_long_long(const void *ll1, const void *ll2) {
    long long ll1_ll;
    long long ll2_ll;
    memcpy(&ll1_ll, ll1, sizeof(long long));
    memcpy(&ll2_ll, ll2, sizeof(long long));
    return(ll1_ll - ll2_ll);
}

double conditional_print_roll_minmax(double ndice, double dicesize, gsl_rng *rng, bool print_rolls, enum minmax minormax, double nkeep) {
    long long *rolls;
    if ((rolls = malloc(ndice * sizeof(long long))) == NULL) {
        puts("Out of memory.");
        exit(1);
    }
    long long ndice_i = (int) ndice;
    long long dicesize_i = (int) dicesize;
    long long nkeep_i = (int) nkeep;
    long long sum = 0;
    long long aroll = 0;
    for (size_t i=0; i<ndice_i; i++) {
        aroll = uniform_distribution(1, dicesize_i, rng);
        rolls[i] = aroll;
        if (print_rolls) {
            printf("%lld\n", aroll);
        }
    }
    
    qsort(rolls, ndice, sizeof(long long), compare_long_long);
    
    size_t start;
    size_t end;
    switch (minormax) {
        case MIN:
            start = 0;
            end = nkeep_i;
            break;
        case MAX:
            start = ndice - nkeep_i;
            end = ndice;
            break;
        default:
            puts("impossible minormax state!");
            exit(1);
            break;
    }
    for (size_t i=start; i<end; i++) {
        sum += rolls[i];
    }
    
    free(rolls);
    return((double) sum);
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
