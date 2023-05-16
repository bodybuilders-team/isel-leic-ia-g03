# 2nd Practical Project

> The report of this practical project is available [here](ia_2nd_project.pdf).

## How to run

### Prolog

To run the Prolog version of the Sudoku solver, consult the file `prolog\sudoku.pl` and run the predicate `sudoku/0`:

```prolog	
?- consult('prolog/sudoku.pl').
true.

?- sudoku.
```

Some algorithms may require a bigger stack size, in that case run the following command:

`swipl --stack-limit=32g .\prolog\sudoku.pl`

This will increase the stack size to 32GB.


### Matlab

To run the Matlab version of the Sudoku solver, run the function `sudoku` located in the file `matlab\sudoku.m`:

```matlab
>> sudoku
```
