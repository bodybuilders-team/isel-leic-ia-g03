% A definition of the planning domain for the assembly line.

% State predicates:
%  - clear(Robot) - Robot is not holding anything
%  - hold(Robot, Object) - Robot is holding an object (piece or product)
%  - on(Robot, Position) - Robot is on Position
%  - assembly(State) - State is a valid assembly state:
%    - clear - assembly site is clear
%    - pos0 - 1xpiece1 is attached to assembly site
%    - pos1 until pos4 - 1xpiece1 and 4xpiece3 are attached to assembly site
%    - pos5 - 1xpiece1, 4xpiece3, 1xpiece4 are attached to assembly site
%    - ready - 1xpiece1, 4xpiece3, 1xpiece4, 1xpiece2 are attached to assembly site
%    - delivered - final product is delivered to delivery site

% Action predicates:
%  - move(Robot, From, To) - Robot moves from From to To
%  - grab(Robot, Object) - Robot grabs Piece from a box, or Robot grabs Product from assembly site
%  - attach(Robot, Piece, State) - Robot attaches Piece to assembly site and assembly is in State
%  - deliver - Robot 3 delivers the final product to the delivery site

% TODO: ver melhor maneira de meter os parafuso

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
% TODO: ver necessidade de adicionar From
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
adds(move(Robot, _, To), [on(Robot, To)]).

% Grab
adds(grab(Robot, Object), [hold(Robot, Object)]).

% Attach
adds(attach(Robot, Piece, State), [clear(Robot), assembly(NewState)]) :-
	add_piece(Piece, State, NewState).

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
