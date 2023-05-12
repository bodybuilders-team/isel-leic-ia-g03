:- consult('depth_first_iterative_deepening.pl').

% s/2 Represents a move in the sudoku puzzle
s(Puzzle, NewPuzzle) :-
    find_empty_cell(Puzzle, RowIdx, ColumnIdx), !,
    find_possible_values(Puzzle, RowIdx, ColumnIdx, PossibleValues),
    member(Value, PossibleValues),
    set_value(Puzzle, RowIdx, ColumnIdx, Value, NewPuzzle).
