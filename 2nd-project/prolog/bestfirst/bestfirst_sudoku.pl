:- consult('bestfirst.pl').

%h(Puzzle, 0) .
h(Puzzle, NumberOfEmpty) :-
    findall([RowIdx, ColumnIdx], (
        find_empty_cell(Puzzle, RowIdx, ColumnIdx)
    ), EmptyList),
    length(EmptyList, NumberOfEmpty).

% s/2 Represents a move in the sudoku puzzle
s(Puzzle, NewPuzzle, 1) :-
    find_empty_cell(Puzzle, RowIdx, ColumnIdx), !,
    find_possible_values(Puzzle, RowIdx, ColumnIdx, PossibleValues),
    member(Value, PossibleValues),
    set_value(Puzzle, RowIdx, ColumnIdx, Value, NewPuzzle).
