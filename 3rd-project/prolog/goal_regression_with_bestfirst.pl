
% State-space representation of means-ends planning with goal regression

:- consult('astar.pl').


% xfy - right associativity 
:- op(300, xfy, ->).

s(Goals -> _, NewGoals -> Action, 1) :-    % All costs are 1
	member(Goal, Goals),
	achieves(Action, Goal),
	can(Action, _),
	preserves(Action, Goals),
	regress(Goals, Action, NewGoals).


goal(Goals -> _) :-
	initial_state(State),                  % User-defined initial situation
	satisfied(State, Goals).               % Goals true in initial situation


h(Goals -> _, H) :-                   % Heuristic estimate
	initial_state(State),
	delete_all(Goals, State, Unsatisfied), % Unsatisfied goals
	length(Unsatisfied, H).                % Number of unsatisfied goals

% Plan with best-first search
plan(Goals, Plan) :-
    bestfirst(Goals -> stop, Solution),
    extract_actions(Solution, Plan).

% Extract actions from a solution
extract_actions([], []).
extract_actions([_ -> Action | Tail], [Action | Actions]) :-
	extract_actions(Tail, Actions).