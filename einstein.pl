%# Rule 1. Each Row must be a re-ordering of the initial Elements specified in the knowledgeBase
%# Rule 2. Elements X and Y must not appear in the same column if the knowledgeBase contains either `mismatch(X, Y).` or `mismatch(Y, X).`
%# Rule 3. Elements X and Y must appear in the same column if the knowledgeBase contains either `match(X, Y).` or `match(Y, X).`

solveBig(Rows) :-
    consult('game2'),
    deconstructBig(Rows, Cols),
    getPuzzleBig(Puzzle),
    hasValidRows(Rows, Puzzle),
    hasValidColumns(Cols),
    printGrid(Rows), !.

solveSmall(Rows) :-
    consult('game'),
    deconstructSmall(Rows, Cols),
    getPuzzleSmall(Puzzle),
    hasValidRows(Rows, Puzzle),
    hasValidColumns(Cols),
    printGrid(Rows), !.

deconstructBig(Rows, Cols) :-
    Row1 = [A1, A2, A3, A4, A5, A6, A7, A8],
    Row2 = [B1, B2, B3, B4, B5, B6, B7, B8],
    Row3 = [C1, C2, C3, C4, C5, C6, C7, C8],
    Row4 = [D1, D2, D3, D4, D5, D6, D7, D8],
    Row5 = [E1, E2, E3, E4, E5, E6, E7, E8],
    Row6 = [F1, F2, F3, F4, F5, F6, F7, F8],
    Row7 = [G1, G2, G3, G4, G5, G6, G7, G8],
    Rows = [Row1, Row2, Row3, Row4, Row5, Row6, Row7],

    Col1 = [A1, B1, C1, D1, E1, F1, G1],
    Col2 = [A2, B2, C2, D2, E2, F2, G2],
    Col3 = [A3, B3, C3, D3, E3, F3, G3],
    Col4 = [A4, B4, C4, D4, E4, F4, G4],
    Col5 = [A5, B5, C5, D5, E5, F5, G5],
    Col6 = [A6, B6, C6, D6, E6, F6, G6],
    Col7 = [A7, B7, C7, D7, E7, F7, G7],
    Col8 = [A8, B8, C8, D8, E8, F8, G8],
    Cols = [Col1, Col2, Col3, Col4, Col5, Col6, Col7, Col8].

getPuzzleBig([A, B, C, D, E, F, G]) :-
    row(1, A),
    row(2, B),
    row(3, C),
    row(4, D),
    row(5, E),
    row(6, F),
    row(7, G).

deconstructSmall(Rows, Cols) :-
    Row1 = [A1, A2, A3, A4],
    Row2 = [B1, B2, B3, B4],
    Row3 = [C1, C2, C3, C4],
    Row4 = [D1, D2, D3, D4],
    Rows = [Row1, Row2, Row3, Row4],

    Col1 = [A1, B1, C1, D1],
    Col2 = [A2, B2, C2, D2],
    Col3 = [A3, B3, C3, D3],
    Col4 = [A4, B4, C4, D4],
    Cols = [Col1, Col2, Col3, Col4].

getPuzzleSmall([A, B, C, D]) :-
    row(1, A),
    row(2, B),
    row(3, C),
    row(4, D).

hasValidRows([], []) :- !.
hasValidRows([CurrentRow|Rows], [CurrentRowOptions|RowOptions]) :-
    listsEqualIgnoreOrder(CurrentRow, CurrentRowOptions),
    hasValidRows(Rows, RowOptions).

listsEqualIgnoreOrder([], []).
listsEqualIgnoreOrder([Head|Tail], List2)  :-
    member(Head, List2),
    select(Head, List2, Remaining),
    listsEqualIgnoreOrder(Tail, Remaining).

hasValidColumns(List) :- maplist(allElementsInColumnMatch, List).

allElementsInColumnMatch([_|[]]).
allElementsInColumnMatch([Head|Tail]) :- elementMatchesAll(Head, Tail), allElementsInColumnMatch(Tail).

elementMatchesAll(X, List) :- maplist(elementsMatch(X), List).

elementsMatch(X, Y) :-  matched(X, Y), !.
elementsMatch(X, Y) :-  \+ mismatched(X, Y), \+ hasConflictingMatch(X, Y).

hasConflictingMatch(X, Y) :- sameRow(Y, Z), matched(X, Z).
hasConflictingMatch(X, Y) :- sameRow(X, Z), matched(Y, Z).

sameRow(X, Y) :- row(_, Z),
    member(X, Z),
    member(Y, Z),
    \+ (X = Y).

matched(X, Y) :- match(X, Y), !.
matched(X, Y) :- match(Y, X), !.
matched(X, Y) :- match(X, Z), matched(Y, Z).

mismatched(X, Y) :- mismatch(X, Y), !.
mismatched(X, Y) :- mismatch(Y, X), !.
mismatched(X, Y) :- match(X, Z), mismatched(Y, Z).

printGrid([]).
printGrid([Head|Tail]) :-
    print(Head),
    print('\n'),
    printGrid(Tail).

testSmall :-
    solveSmall(Rows),
     Rows = [
        [twenty,fifty,penny,nickel],
        [sun,tornadoes,night,sunrise],
        [helicopter,zeppelin,submarine,ambulance],
        [crown,wizard,detective,santa]].