% ================ Hex Game in Prolog ================
% See: https://en.wikipedia.org/wiki/Hex_(board_game)
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
% To run the game, use this query: 
% ?- play.
% ====================================================

% TODOS:
% - Minimax (PvC)
% - Clean up code
% - Change the o and x to black and white

% Start the game
play :-
    writeln('Welcome to the Prolog Hex Game!'),
    get_game_mode(GameMode),
    get_board_size(BoardSize),
    create_board(BoardSize, Board),
    display_board(Board),
    play_game(GameMode, Board). % TODO: dá me ideia q a convenção é overloading, por isso ter play/1 e play/2

% Gets the game mode
get_game_mode(GameMode):-
    write('Please enter the game mode[0(PvP)/1(PvC)]: '),
    read(GameMode),
    between(0, 1, GameMode).

% Gets the board size from the user
get_board_size(BoardSize):-
    write('Please enter the board size[2-11]: '),
    read(BoardSize).

% ==============================================
% ============== Board Creation ================
% ==============================================

% Creates a board with the given size
create_board(BoardSize, Board):-
    between(2, 11, BoardSize),
    create_board_r(BoardSize, BoardSize, Board).

% Creates a board recursively
create_board_r(0, _, []).
create_board_r(Iter, BoardSize, [Row|Board]):-
    create_row(BoardSize, Row),
    NewIter is Iter - 1,
    create_board_r(NewIter, BoardSize, Board).

% Creates a row with the given size
create_row(0, []).
create_row(Iter, [0|Row]):-
    NewIter is Iter - 1,
    create_row(NewIter, Row).

% ==============================================
% ============== Board Display =================
% ==============================================

% Displays the board
display_board(Board):-
    display_column_letters(Board, 'A'),
    display_board_r(Board, 1),
    display_column_letters(Board, 'A').

% Displays the column letters
display_column_letters([], _):- nl.
display_column_letters([_|Board], L):-
    write(' '), write(L),
    char_code(L, LCode),
    NewLCode is LCode + 1,
    char_code(NewL, NewLCode), 
    display_column_letters(Board, NewL).

% Displays the board recursively
display_board_r([], RowNumber) :-
    NumberOfSpaces is RowNumber + 1,
    print_spaces(NumberOfSpaces).
display_board_r([Row|Board], RowNumber):-
    print_spaces(RowNumber),
    write(RowNumber), write(' '),
    display_row(Row),
    writeln(RowNumber),
    NewRowNumber is RowNumber + 1,
    display_board_r(Board, NewRowNumber).

% Prints the spaces before a row
print_spaces(1).
print_spaces(SpacesRemaining):-
    SpacesRemaining > 1,
    write(' '),
    NewSpacesRemaining is SpacesRemaining - 1,
    print_spaces(NewSpacesRemaining).

% Displays a row
% 0 - Empty cell
% o - Player 1 (Black)
% x - Player 2 (White)
display_row([]).
display_row([0|Row]):-
    write('. '),
    display_row(Row).
display_row([o|Row]):-
    %write(' \u2b22 '),
    write('o '),
    display_row(Row).
display_row([x|Row]):-
    %write(' \u2b21 '),
    write('x '),
    display_row(Row).

% ==============================================
% ============== Game Play =====================
% ==============================================

% GameMode: 0 - PvP, 1 - PvC

% Play the game in PvP Mode
play_game(0, Board):-
    play_game_pvp_r(Board, o).
% Play the game in PvC Mode
play_game(1, Board):-
    play_game_pvc_r(Board, o).

% Play the game in PvP Mode recursively
play_game_pvp_r(Board, CurrentPlayer):-
    prompt_player(CurrentPlayer, Move),
    (
    validate_move(Move, Board)
        ->  make_move(Move, CurrentPlayer, Board, NewBoard),
            display_board(NewBoard),
            (
                check_win(NewBoard, CurrentPlayer)
                    -> !, write('Player '), write(CurrentPlayer), write(' won!'), nl
                    ;
                        switch_player(CurrentPlayer, NextPlayer),
                        play_game_pvp_r(NewBoard, NextPlayer)
            )
        ;
            writeln('Invalid move! Try again [row/column]. The move must be in the board and the cell must be empty.'),
            play_game_pvp_r(Board, CurrentPlayer)
    ).

% Check if the given player has won
check_win(Board, Player) :-
    (
        Player = o, check_top_bottom(Board) ; 
        Player = x, check_left_right(Board)
    ).

% Check if player 'o' has connected the top and bottom sides
check_top_bottom(Board) :-
    get_board_size(Board, BoardSize),
    end_node(o, EndNode, BoardSize),
    get_start_nodes(Board, o, StartNodes),
    member(StartNode, StartNodes),
    dfs(Board, StartNode, EndNode, o).

% Check if player 'x' has connected the left and right sides
check_left_right(Board) :-
    get_board_size(Board, BoardSize),
    end_node(x, EndNode, BoardSize),
    get_start_nodes(Board, x, StartNodes),
    member(StartNode, StartNodes),
    dfs(Board, StartNode, EndNode, x).

% Define start node based on player
start_node(o, (1, _)).
start_node(x, (_, 1)).

% Get the start nodes for a given player
% A start node is a cell that belongs to the player and is on the edge of the board
get_start_nodes(Board, Player, StartNodes) :-
    findall(StartNode, (
        start_node(Player, StartNode),
        StartNode = (Row, Column),
        get_cell(Board, Row, Column, Cell),
        Cell = Player
    ), StartNodes).

% Define end node based on player and board size
end_node(o, (BoardSize, _), BoardSize).
end_node(x, (_, BoardSize), BoardSize).

% Get the adjacent cells for a given cell that belong to the same player
get_adjacent_cells(Board, (Row,Column), Player, AdjacentCells) :-
    findall((AdjacentRow,AdjacentColumn), (
        (AdjacentRow is Row-1, AdjacentColumn is Column,     % above
        get_cell(Board, AdjacentRow, AdjacentColumn, Cell),
        Cell = Player)
    ;   (AdjacentRow is Row-1, AdjacentColumn is Column+1,   % above right
        get_cell(Board, AdjacentRow, AdjacentColumn, Cell),
        Cell = Player)
    ;   (AdjacentRow is Row, AdjacentColumn is Column-1,     % left
        get_cell(Board, AdjacentRow, AdjacentColumn, Cell),
        Cell = Player)
    ;   (AdjacentRow is Row, AdjacentColumn is Column+1,     % right
        get_cell(Board, AdjacentRow, AdjacentColumn, Cell),
        Cell = Player)
    ;   (AdjacentRow is Row+1, AdjacentColumn is Column,     % below
        get_cell(Board, AdjacentRow, AdjacentColumn, Cell),
        Cell = Player)
    ;   (AdjacentRow is Row+1, AdjacentColumn is Column-1,   % below left
        get_cell(Board, AdjacentRow, AdjacentColumn, Cell),
        Cell = Player)
    ), AdjacentCells).

% Depth-first search
dfs(Board, StartNode, EndNode, Player) :-
    dfs_r(Board, StartNode, EndNode, Player, [StartNode]).

% Depth-first search recursive
dfs_r(Board, StartNode, EndNode, Player, Visited) :-
    StartNode = EndNode.
dfs_r(Board, StartNode, EndNode, Player, Visited) :-
    StartNode \= EndNode,
    get_adjacent_cells(Board, StartNode, Player, AdjacentCells),
    member(AdjacentCell, AdjacentCells),
    \+ member(AdjacentCell, Visited),
    dfs_r(Board, AdjacentCell, EndNode, Player, [AdjacentCell|Visited]).

% Play the game in PvC Mode recursively
play_game_pvc_r(Board, CurrentPlayer).

% Make a move on the board
make_move(Move, CurrentPlayer, Board, NewBoard):-
    parse_move(Move, Row, Column),
    replace(Board, Row, Column, CurrentPlayer, NewBoard).

% Replace a cell in the board
replace(Board, Row, Column, CurrentPlayer, NewBoard):-
    get_column_number(Column, ColumnNumber),
    nth1(Row, Board, RowList, Rest),
    nth1(ColumnNumber, RowList, _, Transfer),
    % Backwards
    nth1(ColumnNumber, NewRowList, CurrentPlayer, Transfer),
    nth1(Row, NewBoard, NewRowList, Rest).

% Prompt the player for a move
prompt_player(o, Move):-
    write('Player 1, please enter your move [row/column]: '),
    read(Move).

% Prompt the player for a move
prompt_player(x, Move):-
    write('Player 2, please enter your move [row/column]: '),
    read(Move).

% Switch the player
switch_player(o, x).
switch_player(x, o).

% Validate a move on the board
validate_move(Move, Board):-
    parse_move(Move, Row, Column),
    get_board_size(Board, BoardSize),
    between(1, BoardSize, Row),
    get_column_number(Column, ColumnNumber),
    between(1, BoardSize, ColumnNumber),
    get_cell(Board, Row, ColumnNumber, Cell),
    Cell == 0.

% Get a cell from the board
get_cell(Board, Row, Column, Cell):-
    nth1(Row, Board, RowCells),
    nth1(Column, RowCells, Cell).

% Gets the column number from the column letter
get_column_number(Column, ColumnNumber):-
    char_code(Column, ColumnCode),
    ColumnNumber is ColumnCode - 96.

% Parse a move
parse_move(Move, Row, Column):-
    term_string(Move, MoveStr),
    split_string(MoveStr, "/", "", [RowStr, ColumnStr]),
    number_string(Row, RowStr),
    string_chars(ColumnStr, [Column]).

% Get the board size
get_board_size(Board, BoardSize):-
    get_board_size_r(Board, 0, BoardSize).

% Get the board size recursively
get_board_size_r([], Iter, BoardSize):-
    BoardSize is Iter.
get_board_size_r([_|Board], Iter, BoardSize):-
    NewIter is Iter + 1,
    get_board_size_r(Board, NewIter, BoardSize).
