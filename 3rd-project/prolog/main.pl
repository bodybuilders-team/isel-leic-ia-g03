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


% Find a plan to assemble a product
assemble_product :-
    initial_state(State),
    goals(Goals),
    plan(State, Goals, Plan),
    write(Plan).

% Initial state
initial_state([assembly(clear), on(r1, r1_start), on(r2, r2_start), on(r3, r3_start), clear(r1), clear(r2), clear(r3)]).

% Goals
goals([assembly(ready)]).
