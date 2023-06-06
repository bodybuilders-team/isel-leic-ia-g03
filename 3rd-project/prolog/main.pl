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
:- consult('planner/planner_goal_regression_with_bestfirst.pl').
:- set_prolog_flag(stack_limit, 100 000 000 000).


% Find a plan to assemble the product
assemble_product :-
    initial_state(State),
    goals(Goals),
    %time(plan(State, Goals, Plan)), % IDDFS
    time(plan(Goals, Plan)), % Best First
    write('Plan: '), write(Plan), nl.
