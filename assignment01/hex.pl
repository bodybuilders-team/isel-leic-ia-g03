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

% Start the game
play :-
    writeln('Welcome to the Prolog Hex Game!'),
    get_game_mode(GameMode),
    get_board_size(BoardSize),
    create_board(BoardSize, Board),
    display_board(Board),
    play_game(GameMode, Board).

% Gets the game mode
get_game_mode(GameMode):-
    write('Please enter the game mode[0(PvP)/1(PvC)]: '),
    read(GameMode),
    between(0, 1, GameMode).

% Gets the board size from the user
get_board_size(BoardSize):-
    write('Please enter the board size[1-11]: '),
    read(BoardSize).

% ==============================================
% ============== Board Creation ================
% ==============================================

% Creates a board with the given size
create_board(BoardSize, Board):-
    between(1, 11, BoardSize),
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
            switch_player(CurrentPlayer, NextPlayer),
            play_game_pvp_r(NewBoard, NextPlayer)
        ;
            writeln('Invalid move! Try again [row/column]. The move must be in the board and the cell must be empty.'),
            play_game_pvp_r(Board, CurrentPlayer)
    ).

% Play the game in PvC Mode recursively
play_game_pvc_r(Board, CurrentPlayer).

% Make a move on the board
make_move(Move, CurrentPlayer, Board, NewBoard):-
    parse_move(Move, Row, Column),
    replace(Board, Row, Column, CurrentPlayer, NewBoard),
    (
        check_win(NewBoard, CurrentPlayer, Row, Column)
            ->  write('Player '), write(CurrentPlayer), write(' won!'), nl
            ;
                true
    ).
    
% Check if the player won
check_win(Board, CurrentPlayer, RowNumber, Column):-
    get_column_number(Column, ColumnNumber),
    check_win_r(Board, CurrentPlayer, RowNumber, ColumnNumber).

% Check win recursively
check_win_r(Board, CurrentPlayer, RowNumber, ColumnNumber):-
    get_cell(Board, RowNumber, ColumnNumber, Cell),
    Cell == CurrentPlayer,

    PrevRowNumber is RowNumber - 1,
    
    check_win_r(Board, CurrentPlayer, PrevRowNumber, ColumnNumber); % Diagonal Up Left
    
    NextColumnNumber is ColumnNumber + 1,
    check_win_r(Board, CurrentPlayer, PrevRowNumber, NextColumnNumber); % Diagonal Up Right
    
    PrevColumnNumber is ColumnNumber - 1,
    check_win_r(Board, CurrentPlayer, RowNumber, PrevColumnNumber); % Left

    check_win_r(Board, CurrentPlayer, RowNumber, NextColumnNumber); % Right

    NextRowNumber is RowNumber + 1,
    check_win_r(Board, CurrentPlayer, NextRowNumber, ColumnNumber); % Diagonal Down Right
    check_win_r(Board, CurrentPlayer, NextRowNumber, PrevColumnNumber). % Diagonal Down Left

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

test(RowNumber, ColumnNumber):-
    NextRowNumber is RowNumber + 1,
    PrevRowNumber is RowNumber - 1,
    NextColumnNumber is ColumnNumber + 1,
    PrevColumnNumber is ColumnNumber - 1,
    writeln(NextRowNumber),
    writeln(PrevRowNumber),
    writeln(NextColumnNumber),
    writeln(PrevColumnNumber),

    false;
    true;
    false.