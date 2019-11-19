all: roll

roll: roll.y
	yacc roll.y
	gcc -Wall -Wpedantic -Iroll y.tab.c -o roll -lm
