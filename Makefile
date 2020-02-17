all: roll

roll: roll.y
	yacc roll.y
	gcc -Wall -Wpedantic y.tab.c -o roll -lm -lgsl -lgslcblas
