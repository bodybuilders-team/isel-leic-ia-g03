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


% s/2 Represents a move in the sudoku puzzle
s(Puzzle, NewPuzzle) :-
    find_empty(Puzzle, RowIdx, ColumnIdx), !,
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