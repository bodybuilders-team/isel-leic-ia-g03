:- consult('bestfirst.pl').

% MRV Heuristic -> find the cell with the least possible values
h(Puzzle, H) :-
    findall(PossibleValues, (
        find_empty(Puzzle, RowIdx, ColumnIdx),
        find_possible_values(Puzzle, RowIdx, ColumnIdx, PossibleValues)
    ), PossibleValuesList),
    maplist(length, PossibleValuesList, PossibleValuesLengths),
    min_list(PossibleValuesLengths, H).

% s/2 Represents a move in the sudoku puzzle
s(Puzzle, NewPuzzle, Cost) :- % TODO: apply Cost
    find_empty(Puzzle, RowIdx, ColumnIdx),
    %between(1, 9, Value),
    find_possible_values(Puzzle, RowIdx, ColumnIdx, PossibleValues),
    member(Value, PossibleValues),
    set_value(Puzzle, RowIdx, ColumnIdx, Value, NewPuzzle),
    Cost = 1.

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
