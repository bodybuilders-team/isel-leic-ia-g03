% A definition of the planning domain for the assembly line.

% clear(Robot) - Robot is not holding anything
% hold(Robot, Piece) - Robot is holding Piece
% on(Robot, Position) - Robot is on Position
% free(Position) - Position is clear
% move(Robot, From, To) - Robot moves from From to To
% grab(Robot, Object) - Robot grabs Piece from a box, or Robot grabs Product from assembly site
% attach(Robot, Piece, State) - Robot attaches Piece to assembly site and assembly is in State
% deliver() - Robot 3 delivers the final product to the delivery site
% assembly(State) - State is a valid assembly state:
%   clear - assembly site is clear
%   pos0 - 1xpiece1 is attached to assembly site
%   pos1 until pos4 - 1xpiece1 and 4xpiece3 are attached to assembly site
%   pos5 - 1xpiece1, 4xpiece3, 1xpiece4 are attached to assembly site
%   ready - 1xpiece1, 4xpiece3, 1xpiece4, 1xpiece2 are attached to assembly site
%   delivered - final product is delivered to delivery site

% Robots
% robot(Name, Capabilities)
robot(r1, [move, grab, attach]).
robot(r2, [move, grab, attach]).
robot(r3, [move, grab, attach, deliver]).

% Positions
position(box1).
position(box2).
position(box3).
position(box4).
position(assembly_site).
position(delivery_site).
position(r1_start).
position(r2_start).
position(r3_start).

% Objects
% object(Name, Position)
object(piece1, box1).
object(piece2, box2).
object(piece3, box3).
object(piece4, box4).
object(product, assembly_site).

% ======================================
% ============== ACTIONS ===============
% - Move
% - Grab
% - Attach
% - Deliver
% ======================================

% Move robot from one position to another
can(move(Robot, From, To), [on(Robot, From), free(To)]) :-
	robot(Robot, Capabilities),
	member(move, Capabilities),
	position(From),
	position(To),
	From \== To.

% Grab something (piece from box or final product from assembly site)
can(grab(r3, product), [on(r3, assembly_site), assembly(ready), clear(r3)]).
can(grab(Robot, Object), [on(Robot, From), clear(Robot)]) :-
	robot(Robot, Capabilities),
	member(grab, Capabilities),
	object(Object, From).

% Attach a part
can(attach(Robot, Piece, State), [hold(Robot, Piece), on(Robot, assembly_site), assembly(State)]) :-
	robot(Robot, Capabilities),
	member(attach, Capabilities),
	object(Piece, _),
	can_attach(Piece, State).

% Deliver final product
can(deliver(), [hold(r3, product), on(r3, delivery_site)]).


% ======================================
% ============== UTILS =================
% ======================================

% can_attach(Piece, State)
% Piece can be attached to the assembly site if State is a valid assembly state
can_attach(piece1, clear). % Piece 1 is the first piece to be attached
can_attach(piece2, pos5).  % Piece 2 is the last piece to be attached
can_attach(piece3, State) :- % Piece 3 can be attached if piece 1 is attached
	member(State, [pos0, pos1, pos2, pos3]).
can_attach(piece4, pos4).% Piece 4 can be attached if piece 1 and 3xpiece3 are attached


% add_piece(Piece, State, NewState)
add_piece(piece1, clear, pos0).
add_piece(piece2, pos5, ready).
add_piece(piece3, State, NewState) :-
	member(State, [pos0, pos1, pos2, pos3]),
	next_position(State, NewState).
add_piece(piece4, pos4, pos5).

next_position(pos0, pos1).
next_position(pos1, pos2).
next_position(pos2, pos3).
next_position(pos3, pos4).

% ======================================
% ============== EFFECTS ===============
% ======================================

% Move
adds(move(Robot, From, To), [on(Robot, To), free(From)]).

% Grab
% If the object is the final product, then the assembly site is cleared
adds(grab(r3, product), [hold(r3, product)]).
% Otherwise, the robot is holding a piece
adds(grab(Robot, Object), [hold(Robot, Object)]).

% Attach
adds(attach(Robot, Piece, State), [clear(Robot), assembly(NewState)]) :-
	add_piece(Piece, State, NewState).

% Deliver
adds(deliver(), [clear(r3), assembly(delivered)]).


% Move
deletes(move(Robot, From, To), [on(Robot, From), free(To)]).

% Grab
deletes(grab(Robot, _), [clear(Robot)]).

% Attach
deletes(attach(Robot, Piece, State), [hold(Robot, Piece), assembly(State)]).

% Deliver
deletes(deliver(), [hold(r3, product)]).


% This can be improved for better efficiency by observing that some combinations
% of goals are impossible.
%
% impossible(Goal, Goals)
%
% which says that Goal is not possible in combination with goals Goals; that is, both
% Goal and Goals can never be achieved because they are incompatible.

% Impossible predicate for on(X, X)
impossible(on(X, X), _).

% Impossible predicate for on(X, Y)
impossible(on(X, Y), Goals) :-
    % If free(Y) is in Goals, it's impossible for X to be on Y
    member(free(Y), Goals)
    ;
    % If on(X, Y1) is in Goals and Y1 is not equal to Y, it's impossible for X to be on Y
    member(on(X, Y1), Goals), Y1 \== Y
    ;
    % If on(X1, Y) is in Goals and X1 is not equal to X, it's impossible for X to be on Y
    member(on(X1, Y), Goals), X1 \== X.

% Impossible predicate for free(Position)
impossible(free(Position), Goals) :-
    % If on(_, Position) is in Goals, it's impossible for Position to be free
    member(on(_, Position), Goals).

% Impossible predicate for clear(Robot)
impossible(clear(Robot), Goals) :-
    % If hold(Robot, _) is in Goals, it's impossible for Robot to be clear
    member(hold(Robot, _), Goals).
