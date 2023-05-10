:- use_module(library(clpfd)).

goal(Puzzle) :-
    length(Puzzle, 9), maplist(same_length(Puzzle), Puzzle),
    append(Puzzle, Vs), Vs ins 1..9,
    maplist(all_distinct, Puzzle),
    transpose(Puzzle, Columns),
    maplist(all_distinct, Columns),
    Puzzle = [As,Bs,Cs,Ds,Es,Fs,Gs,Hs,Is],
    blocks(As, Bs, Cs), blocks(Ds, Es, Fs), blocks(Gs, Hs, Is).

blocks([], [], []).
blocks([N1,N2,N3|Ns1], [N4,N5,N6|Ns2], [N7,N8,N9|Ns3]) :-
    all_distinct([N1,N2,N3,N4,N5,N6,N7,N8,N9]),
    blocks(Ns1, Ns2, Ns3).