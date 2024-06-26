% Finds the first empty cell in the puzzle
find_empty_cell(Puzzle, RowIdx, ColumnIdx) :-
    nth0(RowIdx, Puzzle, RowList),
    nth0(ColumnIdx, RowList, '_').

% TODO: THIS DOES NOT WORK
% Finds a random empty cell in the puzzle
find_random_empty_cell(Puzzle, RowIdx, ColumnIdx) :-
    findall([RowIdx, ColumnIdx], (
        nth0(RowIdx, Puzzle, RowList),
        nth0(ColumnIdx, RowList, '_')
    ), EmptyCells),
    random_permutation(EmptyCells, [[RowIdx, ColumnIdx]|_]).
    % or this: random_member([RowIdx, ColumnIdx], EmptyCells).

% Finds the possible values for a cell in the puzzle
% considering the current state of the puzzle
find_possible_values(Puzzle, RowIdx, ColumnIdx, ShuffledPossibleValues) :-
    findall(Value, (
        between(1, 9, Value),
        set_value(Puzzle, RowIdx, ColumnIdx, Value, NewPuzzle),
        valid_unfilled(NewPuzzle)
    ), PossibleValues),
    random_permutation(PossibleValues, ShuffledPossibleValues).

% Sets the value of a cell in the puzzle
set_value(Puzzle, RowIdx, ColumnIdx, Value, NewPuzzle) :-
    nth0(RowIdx, Puzzle, RowList, Rest),
    nth0(ColumnIdx, RowList, _, Transfer),
    % Backwards
    nth0(ColumnIdx, NewRowList, Value, Transfer),
    nth0(RowIdx, NewPuzzle, NewRowList, Rest).


% Checks if the puzzle is valid with unfilled cells
valid_unfilled(Puzzle) :-
    maplist(legal_row_column, Puzzle),
    transpose(Puzzle, Columns),
    maplist(legal_row_column, Columns),
    Puzzle = [As,Bs,Cs,Ds,Es,Fs,Gs,Hs,Is],
    legal_squares(As, Bs, Cs),
    legal_squares(Ds, Es, Fs),
    legal_squares(Gs, Hs, Is).

% Checks if a row or column is valid
legal_row_column(List) :- 
    include(number, List, Remaining),
    all_distinct(Remaining).

% Checks if a square/subgrid is valid
legal_squares([], [], []).
legal_squares([N1,N2,N3|Ns1], [N4,N5,N6|Ns2], [N7,N8,N9|Ns3]) :-
    legal_row_column([N1,N2,N3,N4,N5,N6,N7,N8,N9]),
    legal_squares(Ns1, Ns2, Ns3).