depth_first_iterative_deepening(Node, Solution) :-
	path(Node, GoalNode, Solution),
	goal(GoalNode).

path(Node, Node, [Node]). % Single node path

path(FirstNode, LastNode, [LastNode | Path]) :-
	path(FirstNode, OneButLast, Path), % Path up to one-but-last node
	s(OneButLast, LastNode),           % Last step
	\+ member(LastNode, Path).         % No cycle