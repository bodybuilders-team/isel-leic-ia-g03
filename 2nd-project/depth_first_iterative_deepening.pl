depth_first_iterative_deepening( Node, Solution) :-
	path( Node, GoalNode, Solution),
	goal( GoalNode).

s(a, b).
s(a, c).
s(b, d).
s(b, e).
s(d, h).
s(e, i).
s(e, j).
s(c, f).
s(c, g).
s(f, k).

goal(j).
goal(f).

path(Node, Node, [Node]). % Single node path

path(FirstNode, LastNode, [LastNode | Path]) :-
	path(FirstNode, OneButLast, Path), % Path up to one-but-last node
	s(OneButLast, LastNode),           % Last step
	\+ member(LastNode, Path).         % No cycle