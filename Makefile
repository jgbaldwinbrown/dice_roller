all: hoc

hoc: hoc.y
	yacc hoc.y
	gcc -Wall -Wpedantic -Ihoc1h y.tab.c -o hoc1 -lm
