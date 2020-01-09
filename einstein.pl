%# Rule 1. Each Row must be a re-ordering of the initial Elements specified in the knowledgeBase
%# Rule 2. Elements X and Y must not appear in the same column if the knowledgeBase contains either `mismatch(X, Y).` or `mismatch(Y, X).`
%# Rule 3. Elements X and Y must appear in the same column if the knowledgeBase contains either `match(X, Y).` or `match(Y, X).`

solve :-
    consult('game'),
    deconstruct(Rows, Cols),
    hasValidRows(Rows),
    hasValidColumns(Cols),
    printGrid(Rows), !.

deconstruct(Rows, Cols) :-
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

getRowOptions([Row1Options, Row2Options, Row3Options, Row4Options]) :-
    row(A, Row1Options),
    row(B, Row2Options),
    row(C, Row3Options),
    row(D, Row4Options),
    fd_all_different([A, B, C, D]).

hasValidRows([], []).
hasValidRows([CurrentRow|Rows], [CurrentRowOptions|RowOptions]) :-
    listsEqualIgnoreOrder(CurrentRow, CurrentRowOptions),
    hasValidRows(Rows, RowOptions).
hasValidRows(Rows) :-
    getRowOptions(RowOptions),
    hasValidRows(Rows, RowOptions).

listsEqualIgnoreOrder([], []).
listsEqualIgnoreOrder([Head|Tail], List2)  :-
    member(Head, List2),
    select(Head, List2, Remaining),
    listsEqualIgnoreOrder(Tail, Remaining).

hasValidColumns([]).
hasValidColumns([CurrentColumn|Tail]) :-
    allElementsInColumnMatch(CurrentColumn),
    hasValidColumns(Tail).

allElementsInColumnMatch([_|[]]).
allElementsInColumnMatch([Head|Tail]) :- elementMatchesAll(Head, Tail), allElementsInColumnMatch(Tail).

elementMatchesAll(_, []).
elementMatchesAll(X, [Head|Tail]) :- elementsMatch(X, Head), elementMatchesAll(X, Tail).

elementsMatch(X, Y) :-  \+ mismatched(X, Y), \+ hasConflictingMatch(X, Y).

hasConflictingMatch(X, Y) :- sameRow(Y, Z), matched(X, Z).
hasConflictingMatch(X, Y) :- sameRow(X, Z), matched(Y, Z).

sameRow(X, Y) :- row(_, Z),
    member(X, Z),
    member(Y, Z),
    \+ (X = Y).

matched(X, Y) :- match(X, Y).
matched(X, Y) :- match(Y, X).

mismatched(X, Y) :- mismatch(X, Y).
mismatched(X, Y) :- mismatch(Y, X).

printGrid([]).
printGrid([Head|Tail]) :-
    print(Head),
    print('\n'),
    printGrid(Tail).