% =========== Assembly Planning in Prolog ============
% @ISEL, 2022-2023 Summer Semester
% BSc in Computer Science and Engineering
% Artificial Intelligence
% ====================================================
% Authors:
%   - 48280 André Jesus
%   - 48287 Nyckollas Brandão
% Professor:
%   - Nuno Leite
% ====================================================
% To run the application, use this query: 
% ?- assemble_product.
% ====================================================

:- consult('domain.pl').
:- consult('planner/planner_goal_regression.pl').
:- consult('planner/bestfirst/planner_goal_regression_with_bestfirst.pl').
:- consult('planner/pop/pop.pl').
:- set_prolog_flag(stack_limit, 100 000 000 000).


% Find a plan to assemble the product
assemble_product :-
    writeln('Welcome to the Assembly Planner!'), nl,
    
    write('Initial state: '), initial_state(State), write(State), nl,
    write('Goals: '), goals(Goals), write(Goals), nl, nl,

    planner(Planner),
    find_plan(Planner, State, Goals). % Find a plan and measure the time it takes

% Choose the planner to use
planner(Planner) :-
    write('Available planners:'), nl,
    write('1 - Goal Regression'), nl,
    write('2 - Goal Regression with Best First'), nl,
    write('3 - Partial Order Planning'), nl,
    
    write('Choose a planner [1-3]: '), read(Planner),
    between(1, 3, Planner).


% Plan using Goal Regression
find_plan(1, State, Goals) :-
    time(plan(State, Goals, Plan)),
    write('Plan: '), write(Plan), nl.

% Plan using Goal Regression with Best First
find_plan(2, Goals, Plan) :-
    time(plan(Goals, Plan)),
    write('Plan: '), write(Plan), nl.

% Plan using Partial Order Planning
find_plan(3, State, Goals) :-
    time(plan_with_pop(State, Goals, Plan)),
    show_pop(Plan).