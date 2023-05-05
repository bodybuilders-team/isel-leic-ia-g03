% goal/1 Checks if the puzzle is solved
goal(Puzzle) :-
    rows_valid(Puzzle),
    columns_valid(Puzzle),
    subgrids_valid(Puzzle).

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