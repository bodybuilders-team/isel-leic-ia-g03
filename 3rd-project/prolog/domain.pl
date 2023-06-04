% A definition of the planning domain for the assembly line.

% clear(Robot) - Robot is not holding anything
% hold(Robot, Piece) - Robot is holding Piece
% on(Robot, Position) - Robot is on Position
% free(Position) - Position is clear
% move(Robot, From, To) - Robot moves from From to To
% grab(Robot, Piece, Box) - Robot grabs Piece from Box
% attach(Robot, Piece, Position) - Robot attaches Piece to Position
% deliver(Robot, Product, Position) - Robot delivers Product to Position
% assembly(State) - State is a valid assembly state:
%   clear - assembly site is clear
%   pos0 - 1xpiece1 is attached to assembly site
%   pos1 until pos4 - 1xpiece1 and 4xpiece3 and 1xpiece4 are being attached to assembly site
%   pos5 - 1xpiece1, 4xpiece3, 1xpiece4 are attached to assembly site
%   ready - 1xpiece1, 4xpiece3, 1xpiece4, 1xpiece2 are attached to assembly site


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

% Pieces to be assembled
% piece(Type, Box)
piece(type1, box1).
piece(type2, box2).
piece(type3, box3).
piece(type4, box4).

% Capabilities
% Move robot from one position to another
can(move(Robot, From, To), [on(Robot, From), free(To)]) :-
	robot(Robot, Capabilities),
	member(move, Capabilities),
	position(From),
	position(To),
	From \== To.

adds(move(Robot, From, To), [on(Robot, To), free(From)]).
deletes(move(Robot, From, To), [on(Robot, From), free(To)]).


% Grab a part from a box
can(grab(Robot, Piece, Box), [clear(Robot), on(Robot, Box)]) :-
	robot(Robot, Capabilities),
	member(grab, Capabilities),
	piece(Piece, Box),
	position(Box).

adds(grab(Robot, Piece, Box), [hold(Robot, Piece)]).
deletes(grab(Robot, Piece, Box), [clear(Robot)]).


% Attach a part
can(attach(Robot, Piece), [hold(Robot, Piece), on(Robot, assembly_site), assembly(State)]) :-
	robot(Robot, Capabilities),
	member(attach, Capabilities),
	piece(Piece, _),
	can_attach(Piece, State).

can_attach(type1, clear). % Piece 1 is the first piece to be attached
can_attach(type2, pos5).  % Piece 2 is the last piece to be attached
can_attach(type3, State) :- % Piece 3 can be attached if piece 1 is attached
	pos0 \== State;
	pos1 \== State;
	pos2 \== State;
	pos3 \== State;
	pos4 \== State.
can_attach(type4, State) :- % Piece 4 can be attached if piece 1 is attached
	pos0 \== State;
	pos1 \== State;
	pos2 \== State;
	pos3 \== State;
	pos4 \== State.

adds(attach(Robot, Piece), [clear(Robot), assembly(NewState)]) :-
	assembly(State),
	add_piece(Piece, State, NewState).
deletes(attach(Robot, Piece), [hold(Robot, Piece), assembly(State)]).

add_piece(type1, clear, pos0).
add_piece(type2, pos5, ready).
add_piece(type3, State, NewState) :-
	State = pos0, NewState = pos1;
	State = pos1, NewState = pos2;
	State = pos2, NewState = pos3;
	State = pos3, NewState = pos4;
	State = pos4, NewState = pos5.
add_piece(type4, State, NewState) :-
	State = pos0, NewState = pos1;
	State = pos1, NewState = pos2;
	State = pos2, NewState = pos3;
	State = pos3, NewState = pos4;
	State = pos4, NewState = pos5.

% Deliver a part
can(deliver(Robot, Product), [hold(Robot, Product), on(Robot, delivery_site)]) :-
	robot(Robot, Capabilities),
	member(deliver, Capabilities).

adds(deliver(Robot, Product), [assembly(clear)]). % TODO: fix this assemly_state
deletes(deliver(Robot, Product), [hold(Robot, Product), assembly(ready)]).