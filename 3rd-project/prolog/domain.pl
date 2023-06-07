% A definition of the planning domain for the assembly line.

% State predicates:
%  - clear(Robot) - Robot is not holding anything
%  - hold(Robot, Piece) - Robot is holding Piece
%  - on(Robot, Place) - Robot is on Place
%  - inserted(Position) - Piece inserted in Position (pos0, pos1, pos2, pos3, pos4, pos5)
%  - clear(Position) - Position is clear (no piece inserted)

% Action predicates:
%  - move(Robot, From, To) - Robot moves from From to To
%  - grab(Robot, Piece) - Robot grabs Piece
%  - attach(Robot, Piece, Position) - Robot attaches Piece to assembly site in Position
%  - deliver - Robot 3 delivers the final product

% Initial state
initial_state([
	% Robots in starting position and not holding anything
	on(r1, start), clear(r1),
	on(r2, start), clear(r2),
	on(r3, start), clear(r3),

	% Assembly site is clear - no piece is inserted
	clear(pos0), clear(pos1), clear(pos2), clear(pos3), clear(pos4), clear(pos5), clear(pos6)
]).

% Goals
goals([inserted(pos0), inserted(pos1)]). % delivered

% Robots
robot(r1).
robot(r2).
robot(r3).

% Places
place(start).
place(box1).
place(box2).
place(box3).
place(box4).
place(assembly_site).

% Pieces - piece(Piece, Box)
piece(piece1, box1).
piece(piece2, box2).
piece(piece3, box3).
piece(piece4, box4).

% Assembly Positions - assembly(Position, Piece)
assembly(pos0, piece1).
assembly(pos1, piece3).
assembly(pos2, piece3).
assembly(pos3, piece3).
assembly(pos4, piece3).
assembly(pos5, piece4).
assembly(pos6, piece2).


% ======================================
% ============== ACTIONS ===============
% ======================================

% Move
% Move to assembly site only if holding a piece and piece is needed
can(move(Robot, From, assembly_site), [on(Robot, From), hold(Robot, Piece), clear(Position)]) :-
	robot(Robot),
	place(From),
	assembly(Position, Piece).

% Move to box only if not holding anything, and piece is needed
can(move(Robot, From, Box), [on(Robot, From), clear(Robot), clear(Position)]) :-
	robot(Robot),
	place(From),
	place(Box),
	Box \== start,
	Box \== assembly_site,
	piece(Piece, Box),
	assembly(Position, Piece).

% Grab 
can(grab(Robot, Piece), [on(Robot, From), clear(Robot), clear(Position)]) :-
	robot(Robot),
	piece(Piece, From),
	assembly(Position, Piece).

% Attach 
can(attach(Robot, piece1, pos0), [hold(Robot, piece1), on(Robot, assembly_site), clear(pos0)]) :-
	robot(Robot).
can(attach(Robot, piece3, Position), [hold(Robot, piece3), on(Robot, assembly_site), clear(Position), inserted(pos0)]) :-
	robot(Robot),
	assembly(Position, piece3).
can(attach(Robot, piece4, pos5), [hold(Robot, piece4), on(Robot, assembly_site), clear(pos5), inserted(pos0)]) :-
	robot(Robot).
can(attach(Robot, piece2, pos6), [hold(Robot, piece2), on(Robot, assembly_site), clear(pos6), inserted(pos1), inserted(pos2), inserted(pos3), inserted(pos4), inserted(pos5)]) :-
	robot(Robot).

% Deliver final assembly
can(deliver, [inserted(pos6)]).


% ======================================
% ============== ADDS ==================
% ======================================

% Move
adds(move(Robot, _, To), [on(Robot, To)]).

% Grab
adds(grab(Robot, Piece), [hold(Robot, Piece)]).

% Attach
adds(attach(Robot, piece1, pos0), [clear(Robot), inserted(pos0)]).
adds(attach(Robot, piece3, pos1), [clear(Robot), inserted(pos1)]).
adds(attach(Robot, piece3, pos2), [clear(Robot), inserted(pos2)]).
adds(attach(Robot, piece3, pos3), [clear(Robot), inserted(pos3)]).
adds(attach(Robot, piece3, pos4), [clear(Robot), inserted(pos4)]).
adds(attach(Robot, piece4, pos5), [clear(Robot), inserted(pos5)]).
adds(attach(Robot, piece2, pos6), [clear(Robot), inserted(pos6)]).

% Deliver
adds(deliver, [delivered]).


% ======================================
% ============= DELETES ================
% ======================================

% Move
deletes(move(Robot, From, _), [on(Robot, From)]).

% Grab
deletes(grab(Robot, _), [clear(Robot)]).

% Attach
deletes(attach(Robot, piece1, pos0), [hold(Robot, piece1), clear(pos0)]).
deletes(attach(Robot, piece3, pos1), [hold(Robot, piece3), clear(pos1)]).
deletes(attach(Robot, piece3, pos2), [hold(Robot, piece3), clear(pos2)]).
deletes(attach(Robot, piece3, pos3), [hold(Robot, piece3), clear(pos3)]).
deletes(attach(Robot, piece3, pos4), [hold(Robot, piece3), clear(pos4)]).
deletes(attach(Robot, piece4, pos5), [hold(Robot, piece4), clear(pos5)]).
deletes(attach(Robot, piece2, pos6), [hold(Robot, piece2), clear(pos6)]).

% Deliver
deletes(deliver, []).


% ======================================
% =========== IMPOSSIBLE ===============
% ======================================

% Impossible for Robot to be on two different places
impossible(on(Robot, Place), Goals) :-
    member(on(Robot, OtherPlace), Goals), 
	OtherPlace \== Place.

% Impossible for Robot to hold an piece and be clear
impossible(clear(Robot), Goals) :-
    member(hold(Robot, _), Goals).

% Impossible for Robot to hold an piece and be clear
impossible(hold(Robot, _), Goals) :-
	member(clear(Robot), Goals).

% Impossible for Robot to hold two different pieces
impossible(hold(Robot, Piece), Goals) :-
	member(hold(Robot, OtherPiece), Goals),
	Piece \== OtherPiece.


% ======================================
% =========== FOR POP ==================
% ======================================

:- op(100, fx, ~).     % Operator for negated conditions

% Move
effects(move(Robot, From, To), [on(Robot, To), ~on(Robot, From)]).

% Grab
effects(grab(Robot, Piece), [hold(Robot, Piece), ~clear(Robot)]).

% Attach
effects(attach(Robot, Piece, Position), [~clear(Position), inserted(Position), ~hold(Robot, Piece)]).

% Deliver
effects(deliver, [delivered]).

% Negated goals always inconsistent
inconsistent(G, ~G).
inconsistent(~G, G).

% Robot can't be on two different places
inconsistent(on(Robot, Place), on(Robot, OtherPlace)) :-
	OtherPlace \== Place.

% Robot can't hold two different pieces
inconsistent(hold(Robot, Piece), hold(Robot, OtherPiece)) :-
	Piece \== OtherPiece.

% Robot can't be clear and hold an piece
inconsistent(clear(Robot), hold(Robot, _)).
inconsistent(hold(Robot, _), clear(Robot)).

inconsistent(delivered, clear(Position)) :-
	assembly(Position, _).