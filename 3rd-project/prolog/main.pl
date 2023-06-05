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
:- consult('means_ends_planner_goal_regression.pl').
:- consult('goal_regression_with_bestfirst.pl').
%:- set_prolog_flag(stack_limit, 10 000 000 000).


% Find a plan to assemble a product
assemble_product :-
    initial_state(State),
    goals(Goals),
    %time(plan(State, Goals, Plan)), % IDDFS
    time(plan(Goals, Plan)), % Best First
    write('Plan: '), write(Plan), nl.

% Initial state
initial_state([assembly(clear), on(r1, r1_start), on(r2, r2_start), on(r3, r3_start), clear(r1), clear(r2), clear(r3), free(box1), free(box2), free(box3), free(box4), free(assembly_site), free(delivery_site)]).

% Goals
goals([assembly(pos2)]).
