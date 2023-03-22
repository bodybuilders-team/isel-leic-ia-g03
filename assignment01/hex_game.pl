% ============= Hex Game in Prolog =============
% ==============================================
% @ISEL, 2022-2023 Summer Semester
% BsC in Computer Science and Engineering
% Artificial Intelligence
% ==============================================
% Authors:
%   - 48280 André Jesus
%   - 48287 Nyckollas Brandão
% Professor:
%   - Nuno Leite
% ==============================================
% To run the game, use this query: 
% ?- play.
% ==============================================


% Start the game
play :-
    write('Welcome to the Prolog Hex Game!'), nl,
    get_game_mode(GameMode),
    get_board_size(BoardSize),
    create_board(BoardSize, Board),
    display_board(Board).
    %play_game(GameMode, BoardSize, Board).

% Gets the game mode
get_game_mode(GameMode):-
    write('Please enter the game mode[0-PvP, 1-PvC]: '),
    read(GameMode).

% Gets the board size from the user
get_board_size(BoardSize):-
    write('Please enter the board size[1-11]: '),
    read(BoardSize).

% ==============================================
% ============== Board Creation ================
% ==============================================

% Creates a board with the given size
create_board(BoardSize, Board):-
    BoardSize > 0,
    BoardSize < 12,
    create_board(BoardSize, BoardSize, Board).

% Creates a board recursively
create_board_r(0, _, []).
create_board_r(Iter, BoardSize, [Row|Board]):-
    create_row(BoardSize, Row),
    NewIter is Iter - 1,
    create_board(NewIter, BoardSize, Board).

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
    display_board(Board, 1),
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
    write(RowNumber), nl,
    NewRowNumber is RowNumber + 1,
    display_board(Board, NewRowNumber).

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

% Play the game
%play_game(GameMode, BoardSize, Board):-
    %GameMode = 0.