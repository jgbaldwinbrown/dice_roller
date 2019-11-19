all: roll

roll: roll.y
	yacc roll.y
	gcc -Wall -Wpedantic -Iroll1h y.tab.c -o roll1 -lm
