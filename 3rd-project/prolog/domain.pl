% A definition of the planning domain for the assembly line.

% State predicates:
%  - clear(Robot) - Robot is not holding anything
%  - hold(Robot, Object) - Robot is holding an object (piece or product)
%  - on(Robot, Position) - Robot is on Position
%  - assembly(State) - State is a valid assembly state:
%    - clear - assembly site is clear
%	 - (pos1, pos2, pos3, pos4, pos5) - piece 1 is attached and this state keeps track of the positions of the pieces 3 and 4
%    - (y, n, n, n, n) - piece 1 and one piece 3 are attached
%    - (y, y, n, n, n) - piece 1 and two piece 3 are attached
%    - (y, y, y, n, n) - piece 1 and three piece 3 are attached
%    - (y, y, y, y, n) - piece 1 and four piece 3 are attached
%    - (y, y, y, y, y) - piece 1 and four piece 3 and piece 4 are attached
%    - ready - final product is ready (piece 1, 4xpiece 3, piece 4 and piece 2 are attached)
%    - delivered - final product is delivered

% Action predicates:
%  - move(Robot, From, To) - Robot moves from From to To
%  - grab(Robot, Object) - Robot grabs Piece from a box, or Robot grabs Product from assembly site
%  - attach(Robot, Piece, State) - Robot attaches Piece to assembly site and assembly is in State
%  - deliver - Robot 3 delivers the final product to the delivery site

% Initial state
initial_state([
	assembly(clear), 
	on(r1, r1_start), 
	on(r2, r2_start), 
	on(r3, r3_start), 
	clear(r1), 
	clear(r2), 
	clear(r3)
]).

% Goals
goals([assembly((y, n, n, n, n))]).

% Robots
robot(r1).
robot(r2).
robot(r3).

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
can(move(Robot, From, To), [on(Robot, From)]) :-
	robot(Robot),
	position(From),
	position(To),
	From \== To.

% Grab something (piece from box or final product from assembly site)
can(grab(r3, product), [on(r3, assembly_site), assembly(ready), clear(r3)]).
can(grab(Robot, Object), [on(Robot, From), clear(Robot)]) :-
	robot(Robot),
	object(Object, From),
	Object \== product.

% Attach a part
can(attach(Robot, Piece, State), [hold(Robot, Piece), on(Robot, assembly_site), assembly(State)]) :-
	robot(Robot),
	object(Piece, _),
	can_attach(Piece, State).

% Deliver final product
can(deliver, [hold(r3, product), on(r3, delivery_site)]).


% ======================================
% ============== UTILS =================
% ======================================

% can_attach(Piece, State)
can_attach(piece1, clear).
can_attach(piece3, (n, _, _, _, _)).
can_attach(piece3, (_, n, _, _, _)).
can_attach(piece3, (_, _, n, _, _)).
can_attach(piece3, (_, _, _, n, _)).
can_attach(piece4, (_, _, _, _, n)).
can_attach(piece2, ready).

% attach_piece(Piece, State, NewState)
attach_piece(piece1, clear, (n, n, n, n, n)).
attach_piece(piece3, (n, Pos2, Pos3, Pos4, Pos5), (y, Pos2, Pos3, Pos4, Pos5)).
attach_piece(piece3, (Pos1, n, Pos3, Pos4, Pos5), (Pos1, y, Pos3, Pos4, Pos5)).
attach_piece(piece3, (Pos1, Pos2, n, Pos4, Pos5), (Pos1, Pos2, y, Pos4, Pos5)).
attach_piece(piece3, (Pos1, Pos2, Pos3, n, Pos5), (Pos1, Pos2, Pos3, y, Pos5)).
attach_piece(piece4, (Pos1, Pos2, Pos3, Pos4, n), (Pos1, Pos2, Pos3, Pos4, y)).
attach_piece(piece2, (y, y, y, y, y), ready).

% ======================================
% ============== EFFECTS ===============
% ======================================

% Move
adds(move(Robot, _, To), [on(Robot, To)]).

% Grab
adds(grab(Robot, Object), [hold(Robot, Object)]).

% Attach
adds(attach(Robot, Piece, State), [clear(Robot), assembly(NewState)]) :-
	attach_piece(Piece, State, NewState).

% Deliver
adds(deliver, [clear(r3), assembly(delivered)]).


% Move
deletes(move(Robot, From, _), [on(Robot, From)]).

% Grab
deletes(grab(Robot, _), [clear(Robot)]).

% Attach
deletes(attach(Robot, Piece, State), [hold(Robot, Piece), assembly(State)]).

% Deliver
deletes(deliver, [hold(r3, product), assembly(ready)]).


% ======================================
% =========== IMPOSSIBLE ===============
% ======================================

% Impossible for Robot to be on two different positions
impossible(on(Robot, Position), Goals) :-
    member(on(Robot, OtherPosition), Goals), 
	OtherPosition \== Position.

% Impossible for Robot to hold an object and be clear
impossible(clear(Robot), Goals) :-
    member(hold(Robot, _), Goals).

% Impossible for Robot to hold an object and be clear
impossible(hold(Robot, _), Goals) :-
	member(clear(Robot), Goals).

% Impossible for Robot to hold two different objects
impossible(hold(Robot, Object), Goals) :-
	member(hold(Robot, OtherObject), Goals),
	Object \== OtherObject.

% Impossible for assembly site to be in two different states
impossible(assembly(State), Goals) :-
	member(assembly(OtherState), Goals),
	State \== OtherState.


% ======================================
% =========== FOR POP ==================
% ======================================

:- op(100, fx, ~).     % Operator for negated conditions

% Move
effects(move(Robot, From, To), [on(Robot, To), ~on(Robot, From)]).

% Grab
effects(grab(Robot, Object), [hold(Robot, Object), ~clear(Robot)]).

% Attach
effects(attach(Robot, Piece, State), [clear(Robot), assembly(NewState), ~hold(Robot, Piece), ~assembly(State)]) :-
	attach_piece(Piece, State, NewState).

% Deliver
effects(deliver, [clear(r3), assembly(delivered), ~hold(r3, product), ~assembly(ready)]).

% Negated goals always inconsistent
inconsistent(G, ~G).
inconsistent(~G, G).

% Robot can't be on two different positions
inconsistent(on(Robot, Position), on(Robot, OtherPosition)) :-
	OtherPosition \== Position.

% Robot can't hold two different objects
inconsistent(hold(Robot, Object), hold(Robot, OtherObject)) :-
	Object \== OtherObject.

% Robot can't be clear and hold an object
inconsistent(clear(Robot), hold(Robot, _)).
inconsistent(hold(Robot, _), clear(Robot)).

% Assembly site can't be in two different states
inconsistent(assembly(State), assembly(OtherState)) :-
	State \== OtherState.
