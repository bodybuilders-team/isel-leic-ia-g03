depth_first_iterative_deepening(Node, Solution, Depth) :-
	path(Node, GoalNode, Solution, Depth),
	goal(GoalNode).

path(Node, Node, [Node], _). % Single node path

path(FirstNode, LastNode, [LastNode | Path], Depth) :-
	Depth > 0,
	NewDepth is Depth - 1,
	path(FirstNode, OneButLast, Path, NewDepth), % Path up to one-but-last node
	s(OneButLast, LastNode),           % Last step
	\+ member(LastNode, Path).         % No cycle