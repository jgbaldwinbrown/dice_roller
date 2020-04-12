#include <gsl/gsl_rng.h>
#include <stdbool.h>

int yylex();
void yyerror(char *s);
void warning(char *s, char *t);
long long uniform_distribution(long long rangeLow, long long rangeHigh, gsl_rng *rng);
double roll(double ndice, double dicesize, gsl_rng *rng);
double conditional_print_roll(double ndice, double dicesize, gsl_rng *rng, bool print_rolls);
