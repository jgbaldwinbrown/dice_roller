
# Dice Roller

This is a quick hobby project that I wrote to better understand Flex and Bison, the unix lexer and parser.
I never ended up using Flex because the lexing was so simple, but the use of Bison allows for efficient
and correct parsing of arbitrarily deeply nested arithmetical statements, which is kind of cool.

## Installation

This package requires GCC, Make, and Bison. Install these with your preferred package manager, then enter the following line in the root
directory of this package:

```sh
make
```

This should produce the file '`roll`', which can be run with the command:

```sh
./roll
```

or can be added to a directory included in the user's PATH and run like so:

```sh
roll
```

### Usage

`roll` is a small language that does simple arithmetic (plus, minus, times, divide)
on `double`s. Expressions can be nested arbitrarily deeply with parentheses, and
order of operations is preserved. So, for example, this code:

```
((1+2) * 3) / 7
```

produces the output:

```
1.2857143
```

In addition, arbitrarily many die rolls with whole-number-sided dice can be performed
with the syntax `[0-9]+d[0-9]`, like so:

```
6d12 + 33
	60
```

In addition, a single `q` on a line will quit the program. So, a typical session might look
like the following:

```
6d12 + 33
        60
(8.3 / 9.9) + 2
	2.8383838
q
```

`roll` can also be run in batch mode by simply directing set of commands to standard input in one of the two following ways:

```
cat input.txt | roll
```

```
roll <input.txt
```
