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


% Parts
part(type1).
part(type2).
part(type3).
part(type4).

% Parts contained in each Pos_i box
contains(pos1, type1).
contains(pos2, type2).
contains(pos3, type3).
contains(pos4, type4).

% Places
place(box1).
place(box2).
place(box3).
place(box4).
place(assembly).

% Step 1: Mount type1 on the mounting position
assemble(type1) :-
    contains(Pos, type1),
    \+ mounted(type1),
    mount(type1, Pos),
    assert(mounted(type1)).

% Step 2: Mount type2 on the mounting position
assemble(type2) :-
    contains(Pos, type2),
    \+ mounted(type2),
    mount(type2, Pos),
    assert(mounted(type2)).

% Step 3: Mount type3 on the mounting position
assemble(type3) :-
    contains(Pos, type3),
    \+ mounted(type3),
    mount(type3, Pos),
    assert(mounted(type3)).

% Step 4: Mount type4 on the mounting position
assemble(type4) :-
    contains(Pos, type4),
    \+ mounted(type4),
    mount(type4, Pos),
    assert(mounted(type4)).

% Step 4: Transport assembly to output by robot R3
transport(Robot, pos_assembly, output) :-
    robot(Robot),
    robot_capable(Robot, transport),
    assert(transported).

% Final step: Check if the product is fully assembled
assembled :- mounted(type1), mounted(type2), mounted(type3), transported.

% Robot capabilities
robot(R1).
robot(R2).
robot(R3).

robot_capable(R3, transport).

% Mounting rules
mount(type1, pos1).
mount(type2, pos2).
mount(type3, pos3).
mount(type4, pos4).

% Main program using goal regression
assemble_product :-
    % Initialize variables
    retractall(mounted(_)),
    retractall(transported),

    % Generate assembly plan
    assemble_product_recursive.

% Base case: Product is fully assembled
assemble_product_recursive :-
    assembled.

% Recursive case: Assemble the next part and continue
assemble_product_recursive :-
    part(Part),
    \+ mounted(Part),
    assemble(Part),
    assemble_product_recursive.

% This will generate the assembly plan for the product, mounting the parts in the appropriate positions and transporting the assembly to the 
% output using robot R3.

% Note: The above implementation assumes that you have additional information about the robots and their capabilities. 
% You may need to extend the program with appropriate facts and rules to represent the robot's capabilities and relationships.