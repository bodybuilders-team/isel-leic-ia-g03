% ============= Sudoku Solver in Prolog ==============
% See: https://en.wikipedia.org/wiki/Sudoku
% ====================================================
% @ISEL, 2022-2023 Summer Semester
% BSc in Computer Science and Engineering
% Artificial Intelligence
% ====================================================
% Authors:
%   - 48280 André Jesus
%   - 48287 Nyckollas Brandão
% Professor:
%   - Nuno Leite
% ====================================================
% To run the application, use this query: 
% ?- sudoku.
% ====================================================

:- consult('utils.pl').
:- consult('goal.pl').
:- consult('iterative_deepening/iddfs_sudoku.pl').
:- consult('bestfirst/bestfirst_sudoku.pl').
:- use_module(library(clpfd)).

% Runs the sudoku solver
sudoku :-
    writeln('Welcome to the Sudoku Solver in Prolog!'),
    puzzle_difficulty(Difficulty),
    puzzle(Difficulty, Puzzle),
    writeln('Puzzle:'),
    print_puzzle(Puzzle),
    puzzle_algorithm(Algorithm),
    writeln('Solving...'),
    solve(Puzzle, Algorithm, Solution),
    writeln('Solution:'),
    print_puzzle(Solution).

% Asks the user for the difficulty of the puzzle
puzzle_difficulty(Difficulty) :-
    writeln('Difficulties:'),
    writeln('0 - Easy'),
    writeln('1 - Medium'),
    writeln('2 - Hard'),
    writeln('3 - Very Hard'),
    write('Choose the difficulty of the puzzle [0-3]: '),
    read(Difficulty),
    between(0, 3, Difficulty).

% Asks the user for the algorithm to solve the puzzle
puzzle_algorithm(Algorithm) :-
    writeln('Algorithms:'),
    writeln('0 - Iterative Deepening Depth-First Search (IDDFS)'),
    writeln('1 - Best-First Search (A*)'),
    write('Choose the algorithm to solve the puzzle [0-1]: '),
    read(Algorithm),
    between(0, 1, Algorithm).

% Returns puzzles with different difficulty levels
% puzzle(0, Puzzle) - Easy
% puzzle(1, Puzzle) - Medium
% puzzle(2, Puzzle) - Hard
% puzzle(3, Puzzle) - Expert
% puzzle(4, Puzzle) - Nightmare
% puzzle(5, Puzzle) - Impossible
puzzle(0, [ [_,_,_,9,_,_,5,1,7],
            [_,_,5,_,2,_,_,_,_],
            [_,9,_,5,_,_,8,2,4],
            [3,7,_,_,9,2,1,4,_],
            [4,_,9,_,1,_,6,7,3],
            [_,_,1,_,3,_,_,_,8],
            [6,_,3,_,8,_,4,_,9],
            [_,_,_,_,6,_,_,_,1],
            [_,8,4,_,_,1,7,6,_] ]).

puzzle(1, [ [1,9s,_,6,_,1,_,_,_],
            [_,3,_,_,7,5,_,4,9],
            [_,_,_,9,4,8,_,_,_],
            [1,5,7,_,_,_,_,_,_],
            [_,9,6,_,_,_,2,_,8],
            [2,_,_,1,6,9,_,5,_],
            [4,1,_,3,_,7,_,6,_],
            [_,2,_,5,1,_,3,7,_],
            [7,_,3,4,_,_,1,8,_] ]).

puzzle(2, [ [9,_,2,_,7,_,3,_,_],
            [_,_,_,_,_,8,2,_,_],
            [_,_,6,_,_,5,9,_,_],
            [_,_,_,_,_,_,_,_,_],
            [_,_,9,_,_,7,_,_,5],
            [_,_,1,3,_,_,6,_,_],
            [8,2,_,_,_,_,_,_,_],
            [_,_,7,_,_,1,_,_,4],
            [_,1,_,_,8,_,_,_,6] ]).

puzzle(3, [ [_,_,_,_,_,_,_,_,_],
            [_,_,_,_,_,3,_,8,5],
            [_,_,1,_,2,_,_,_,_],
            [_,_,_,5,_,7,_,_,_],
            [_,_,4,_,_,_,1,_,_],
            [_,9,_,_,_,_,_,_,_],
            [5,_,_,_,_,_,_,7,3],
            [_,_,2,_,1,_,_,_,_],
            [_,_,_,_,4,_,_,_,9] ]). 

puzzle(4, [ [_,_,_,_,_,_,_,_,_],
            [_,_,_,_,_,3,_,8,5],
            [_,_,1,_,2,_,_,_,_],
            [_,_,_,5,_,7,_,_,_],
            [_,_,4,_,_,_,1,_,_],
            [_,9,_,_,_,_,_,_,_],
            [5,_,_,_,_,_,_,7,3],
            [_,_,2,_,1,_,_,_,_],
            [_,_,_,_,4,_,_,_,9] ]).

% ==============================================
% =============== Print Puzzle =================
% ==============================================

% Prints the puzzle
print_puzzle([]).
print_puzzle([H|T]) :-
    print_puzzle_r([H|T], 1).

% Prints the puzzle recursively
print_puzzle_r([], _).
print_puzzle_r([H|T], N) :-
    write(' '),
    print_row(H, 1),
    ((N == 3; N == 6) 
        -> writeln('\n-------+-------+-------')
        ;  writeln('')
    ),
    N1 is N + 1,
    print_puzzle_r(T, N1).

% Prints a row of the puzzle
print_row([], _).
print_row([H|T], N) :-
    (H = '_' -> write(' '); write(H)),
    ((N == 3; N == 6) 
        -> write(' | ')
        ;  write(' ')
    ),
    N1 is N + 1,
    print_row(T, N1).

% ==============================================
% =============== Solve Puzzle =================
% ==============================================

% Solves the puzzle using iterative deepening depth-first search (IDDFS)
solve(Puzzle, 0, Solution) :-
    depth_first_iterative_deepening(Puzzle, [Solution | _]).

% Solves the puzzle using best-first search (A*)
solve(Puzzle, 1, Solution) :-
    bestfirst(Puzzle, [Solution | _]).
