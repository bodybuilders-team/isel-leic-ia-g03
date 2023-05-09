:- consult('bestfirst.pl').

% MRV Heuristic -> find the cell with the least possible values
h(Puzzle, NumberOfEmpty + MinLength) :-
    findall(PossibleValues, (
        find_empty(Puzzle, RowIdx, ColumnIdx),
        find_possible_values(Puzzle, RowIdx, ColumnIdx, PossibleValues)
    ), PossibleValuesList),
    length(PossibleValuesList, NumberOfEmpty),
    (NumberOfEmpty = 0 -> MinLength = 0 ; (
        maplist(length, PossibleValuesList, PossibleValuesLengths),
        min_list(PossibleValuesLengths, MinLength)
    )).

% s/2 Represents a move in the sudoku puzzle
s(Puzzle, NewPuzzle, 1) :-
    find_empty(Puzzle, RowIdx, ColumnIdx),
    find_possible_values(Puzzle, RowIdx, ColumnIdx, PossibleValues),
    member(Value, PossibleValues),
    set_value(Puzzle, RowIdx, ColumnIdx, Value, NewPuzzle).
