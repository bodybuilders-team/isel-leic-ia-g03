# 2nd Practical Project

> The report of this practical project is available [here](ia_2nd_project.pdf).

## Experimental Evaluation

## Iterative Deepening

| Difficulty | Time     |
| ---------- | -------- |
| Easy       | 34.029 s |
| Medium     | 83.602 s |
| Hard       | ? s      |
| Expert     | ? s      |
| Evil       | ? s      |

## A*

| Difficulty | h = 0   | h = No. of empty cells |
| ---------- | ------- | ---------------------- |
| Easy       | 1.227 s | 0.619 s                |
| Medium     | 3.583 s | 2.505 s                |
| Hard       | ? s     | ? s                    |
| Expert     | ? s     | ? s                    |
| Evil       | ? s     | ? s                    |

> `swipl --stack-limit=32g .\prolog\sudoku.pl`

### Conclusions:

* The A* algorithm is faster than the iterative deepening algorithm;
* The heuristic function h = 0 is slower than h = No. of empty cells;
* ...