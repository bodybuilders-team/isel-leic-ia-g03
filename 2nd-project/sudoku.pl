% ================ Sudoku Solver in Prolog ================
% See: https://en.wikipedia.org/wiki/Sudoku
% ====================================================
% @ISEL, 2022-2023 Summer Semester
% BsC in Computer Science and Engineering
% Artificial Intelligence
% ====================================================
% Authors:
%   - 48280 André Jesus
%   - 48287 Nyckollas Brandão
% Professor:
%   - Nuno Leite
% ====================================================
% To run the solver, use this query: 
% ?- sudoku.
% ====================================================

%:- consult('depth_first_iterative_deepening.pl').
:- consult('bestfirst.pl').
:- use_module(library(clpfd)).

% Runs the solver
sudoku :-
    writeln('Welcome to the Sudoku Solver in Prolog!'),
    puzzle_difficulty(Difficulty),
    puzzle(Difficulty, Puzzle),
    writeln('Puzzle:'),
    print_puzzle(Puzzle),
    writeln('Solving...'),
    solve(Puzzle, Solution),
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

% Returns puzzles with different difficulty levels
% puzzle(0, Puzzle) - Easy
% puzzle(1, Puzzle) - Medium
% puzzle(2, Puzzle) - Hard
% puzzle(3, Puzzle) - Very Hard
puzzle(0, [ [_,_,5,2,6,9,7,8,1],
            [6,8,2,5,7,1,4,9,3],
            [1,_,7,8,3,4,5,6,2],
            [8,2,6,1,_,5,3,_,7],
            [3,7,4,6,8,2,9,1,5],
            [9,5,1,7,4,3,6,2,8],
            [5,1,9,_,2,6,8,7,4],
            [2,4,8,9,5,7,1,3,6],
            [7,6,3,4,1,8,2,5,_] ]).

puzzle(1, [ [5,_,_,6,_,1,_,_,_],
            [_,3,_,_,7,5,_,4,9],
            [_,_,_,9,4,8,_,_,_],
            [1,5,7,_,_,_,_,_,_],
            [_,9,6,_,_,_,2,_,8],
            [2,_,_,1,6,9,_,5,_],
            [4,1,_,3,_,7,_,6,_],
            [_,2,_,5,1,_,3,7,_],
            [7,_,3,4,_,_,1,8,_] ]).

puzzle(2, [ [_,_,_,6,_,_,4,_,_],
            [7,_,_,_,_,3,6,_,_],
            [_,_,_,_,9,1,_,8,_],
            [_,_,_,_,_,_,_,_,_],
            [_,5,_,1,8,_,_,_,3],
            [_,_,_,3,_,6,_,4,5],
            [_,4,_,2,_,_,_,6,_],
            [9,_,3,_,_,_,_,_,_],
            [_,2,_,_,_,_,1,_,_] ]).

puzzle(3, [ [_,_,_,_,_,_,_,_,_],
            [_,_,_,_,_,3,_,8,5],
            [_,_,1,_,2,_,_,_,_],
            [_,_,_,5,_,7,_,_,_],
            [_,_,4,_,_,_,1,_,_],
            [_,9,_,_,_,_,_,_,_],
            [5,_,_,_,_,_,_,7,3],
            [_,_,2,_,1,_,_,_,_],
            [_,_,_,_,4,_,_,_,9] ]). 

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
    (nonvar(H) -> write(H); write(' ')),
    ((N == 3; N == 6) 
        -> write(' | ')
        ;  write(' ')
    ),
    N1 is N + 1,
    print_row(T, N1).

% Solves the puzzle
solve(Puzzle, Solution) :-
    depth_first_iterative_deepening(Puzzle, [Solution | _], 1000). % TODO: sus depth
    % bestfirst(Puzzle, Solution).

depth_first_iterative_deepening(Node, Solution, Depth) :-
	path(Node, GoalNode, Solution, Depth),
	goal(GoalNode).

path(Node, Node, [Node], _). % Single node path

path(FirstNode, LastNode, [LastNode | Path], Depth) :-
	Depth > 0,
	NewDepth is Depth - 1,
	path(FirstNode, OneButLast, Path, NewDepth), % Path up to one-but-last node
	s(OneButLast, LastNode),           % Last step
	\+ member(LastNode, Path).         % No cycle

% goal1 Checks if the puzzle is solved
goal(Puzzle) :-
    rows_valid(Puzzle),
    columns_valid(Puzzle),
    subgrids_valid(Puzzle).

%goal(Puzzle) :-
%        length(Puzzle, 9), maplist(same_length(Puzzle), Puzzle),
%        append(Puzzle, Vs), Vs ins 1..9,
%        maplist(all_distinct, Puzzle),
%        transpose(Puzzle, Columns),
%        maplist(all_distinct, Columns),
%        Puzzle = [As,Bs,Cs,Ds,Es,Fs,Gs,Hs,Is],
%        blocks(As, Bs, Cs), blocks(Ds, Es, Fs), blocks(Gs, Hs, Is).

%blocks([], [], []).
%blocks([N1,N2,N3|Ns1], [N4,N5,N6|Ns2], [N7,N8,N9|Ns3]) :-
 %       all_distinct([N1,N2,N3,N4,N5,N6,N7,N8,N9]),
  %      blocks(Ns1, Ns2, Ns3).

rows_valid([]).
rows_valid([Row|Rows]) :-
    sort(Row, Sorted),
    permutation(Sorted, [1,2,3,4,5,6,7,8,9]),
    rows_valid(Rows).

columns_valid(Puzzle) :-
    transpose(Puzzle, Transposed),
    rows_valid(Transposed).

subgrids_valid(Puzzle) :-
    subgrid_valid(0, 0, Puzzle),
    subgrid_valid(0, 3, Puzzle),
    subgrid_valid(0, 6, Puzzle),
    subgrid_valid(3, 0, Puzzle),
    subgrid_valid(3, 3, Puzzle),
    subgrid_valid(3, 6, Puzzle),
    subgrid_valid(6, 0, Puzzle),
    subgrid_valid(6, 3, Puzzle),
    subgrid_valid(6, 6, Puzzle).

subgrid_valid(RowIdx, ColumnIdx, Puzzle) :-
    RowIdx1 is RowIdx + 1,
    RowIdx2 is RowIdx + 2,
    ColumnIdx1 is ColumnIdx + 1,
    ColumnIdx2 is ColumnIdx + 2,
    nth0(RowIdx, Puzzle, Row0),
    nth0(RowIdx1, Puzzle, Row1),
    nth0(RowIdx2, Puzzle, Row2),
    nth0(ColumnIdx, Row0, E00),
    nth0(ColumnIdx1, Row0, E01),
    nth0(ColumnIdx2, Row0, E02),
    nth0(ColumnIdx, Row1, E10),
    nth0(ColumnIdx1, Row1, E11),
    nth0(ColumnIdx2, Row1, E12),
    nth0(ColumnIdx, Row2, E20),
    nth0(ColumnIdx1, Row2, E21),
    nth0(ColumnIdx2, Row2, E22),
    sort([E00, E01, E02, E10, E11, E12, E20, E21, E22], Sorted),
    permutation(Sorted, [1,2,3,4,5,6,7,8,9]).

% example of puzzle solution
/*goal([[4,3,5,2,6,9,7,8,1],[6,8,2,5,7,1,4,9,3],[1,9,7,8,3,4,5,6,2],[8,2,6,1,9,5,3,4,7],[3,7,4,6,8,2,9,1,5],[9,5,1,7,4,3,6,2,8],[5,1,9,3,2,6,8,7,4],[2,4,8,9,5,7,1,3,6],[7,6,3,4,1,8,2,5,9]]).*/

% s2 Represents a move in the sudoku puzzle
s(Puzzle, NewPuzzle) :-
    find_empty(Puzzle, RowIdx, ColumnIdx),
    %between(1, 9, Value),
    find_possible_values(Puzzle, RowIdx, ColumnIdx, PossibleValues),
    member(Value, PossibleValues),
    set_value(Puzzle, RowIdx, ColumnIdx, Value, NewPuzzle).

% find_empty Finds the first empty cell in the puzzle
find_empty(Puzzle, RowIdx, ColumnIdx) :-
    nth0(RowIdx, Puzzle, RowList),
    nth0(ColumnIdx, RowList, '_').

% find_possible_values Finds the possible values for a cell in the puzzle
find_possible_values(Puzzle, RowIdx, ColumnIdx, PossibleValues) :-
    findall(Value, (
        between(1, 9, Value),
        set_value(Puzzle, RowIdx, ColumnIdx, Value, NewPuzzle),
        valid_unfilled(NewPuzzle)
    ), PossibleValues).

% set_value Sets the value of a cell in the puzzle
set_value(Puzzle, RowIdx, ColumnIdx, Value, NewPuzzle) :-
    nth0(RowIdx, Puzzle, RowList, Rest),
    nth0(ColumnIdx, RowList, _, Transfer),
    % Backwards
    nth0(ColumnIdx, NewRowList, Value, Transfer),
    nth0(RowIdx, NewPuzzle, NewRowList, Rest).

% valid_unfilled Checks if the puzzle is valid with unfilled cells
valid_unfilled(Puzzle) :-
    length(Puzzle, 9),
    maplist(same_length(Puzzle), Puzzle),
    maplist(legal_row_column, Puzzle),
    transpose(Puzzle, Columns),
    maplist(legal_row_column, Columns),
    Puzzle = [As,Bs,Cs,Ds,Es,Fs,Gs,Hs,Is],
    legal_squares(As, Bs, Cs),
    legal_squares(Ds, Es, Fs),
    legal_squares(Gs, Hs, Is).

legal_row_column(List) :- 
    include(number, List, Remaining),
    all_distinct(Remaining).

legal_squares([], [], []).
legal_squares([N1,N2,N3|Ns1], [N4,N5,N6|Ns2], [N7,N8,N9|Ns3]) :-
    legal_row_column([N1,N2,N3,N4,N5,N6,N7,N8,N9]),
    legal_squares(Ns1, Ns2, Ns3).