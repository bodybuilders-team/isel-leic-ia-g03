% ====================================================
% A means-ends planner based on goal regression. 
% The planner performs an iterative deepening search.
% ====================================================

% plan/3: Regressively searches for a plan achieving Goals in State
plan(State, Goals, []) :-
	satisfied(State, Goals). % Goals true in State

plan(State, Goals, Plan) :-
	append(PrePlan, [Action], Plan),        % Divide plan achieving breadth-first effect
	select(State, Goals, Goal),             % Select a goal
	achieves(Action, Goal),
	can(Action, Condition),                 % Ensure Action contains no variables
	preserves(Action, Goals),               % Protect Goals
	regress(Goals, Action, RegressedGoals), % Regress Goals through Action
	plan(State, RegressedGoals, PrePlan).


% satisfied/2: Goals are satisfied in State
satisfied(State, Goals) :-
	delete_all(Goals, State, []). % All Goals in State

% select/3: Select a goal from Goals
select(_, Goals, Goal) :- % Select Goal from Goals
	member(Goal, Goals).      % A simple selection principle

% achieves/2: Action achieves Goal
achieves(Action, Goal) :-
	adds(Action, Goals),
	member(Goal, Goals).

% preserves/2: Action preserves Goals
preserves(Action, Goals) :-
	deletes(Action, Relations),
	\+ (member(Goal, Relations),
	    member(Goal, Goals)).

% regress/3: Regress Goals through Action
regress(Goals, Action, RegressedGoals) :-
	adds(Action, NewRelations),
	delete_all(Goals, NewRelations, RestGoals),
	can(Action, Condition),
	addnew(Condition, RestGoals, RegressedGoals).  % Add precond., check imposs.


% addnew/3 is true if NewGoals can be added to OldGoals
% AllGoals is the union of NewGoals and OldGoals
% NewGoals and OldGoals must be compatible
addnew([ ], L, L).

addnew([Goal | _], Goals, _) :-
	impossible(Goal, Goals),   % Goal incompatible with Goals
	!,
	fail.                      % Cannot be added

addnew([X | L1], L2, L3) :-
	member(X, L2), !,          % Ignore duplicate
	addnew(L1, L2, L3).
	
addnew([X | L1], L2, [X | L3]) :-
	addnew(L1, L2, L3).


% delete_all(L1, L2, Diff): Diff is set-difference of lists L1 and L2
delete_all([], _, []).

delete_all([X | L1], L2, Diff) :-
	member(X, L2), !,
	delete_all(L1, L2, Diff).

delete_all([X | L1], L2, [X | Diff]) :-
	delete_all(L1, L2, Diff).


% This can be improved for better efficiency by observing that some combinations
% of goals are impossible. For example, on(a,b) and clear(b) cannot be true at the
% same time. This can be formulated as the relation
%
% impossible( Goal, Goals)
%
% which says that Goal is not possible in combination with goals Goals; that is, both
% Goal and Goals can never be achieved because they are incompatible. For our blocks
% world, such incompatible combinations can be defined as follows:

impossible(on(X, X), _). % Block cannot be on itself

impossible(on(X, Y), Goals) :-
	member(clear(Y), Goals)
	;  % Or
	member(on(X, Y1), Goals), Y1 \== Y % Block cannot be in two places
	;  % Or
	member(on(X1, Y), Goals), X1 \== X. % Two blocks cannot be in same place

impossible(clear(X), Goals) :-
	member(on(_, X), Goals).