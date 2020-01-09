% Rule 1: a valid row uses each item exactly once
% Rule 2: a valid column is if no entry is invalid
% Rule 3: an entry is invalid if there is an explicit mismatch between itself and another element in its column
% Rule 4: an entry is valid if it is not invalid, or if there is an explicit match between itself and another element in its column

import('game.pl').

solve(Puzzle) :-
    deconstruct(Puzzle, Rows, Cols),

    hasValidRows(Rows),
    hasValidColumns(Cols),

    printGrid(Rows), !.

deconstruct(Puzzle, Rows, Cols) :-
    Puzzle = [
        S11, S12, S13, S14,
        S21, S22, S23, S24,
        S31, S32, S33, S34,
        S41, S42, S43, S44
        ],

    Row1 = [S11, S12, S13, S14],
    Row2 = [S21, S22, S23, S24],
    Row3 = [S31, S32, S33, S34],
    Row4 = [S41, S42, S43, S44],
    Rows = [Row1, Row2, Row3, Row4],

    Col1 = [S11, S21, S31, S41],
    Col2 = [S12, S22, S32, S42],
    Col3 = [S13, S23, S33, S43],
    Col4 = [S14, S24, S34, S44],
    Cols = [Col1, Col2, Col3, Col4].

getRowOptions([Row1Options, Row2Options, Row3Options, Row4Options]) :-
    row(A, Row1Options),
    row(B, Row2Options),
    row(C, Row3Options),
    row(D, Row4Options),
    fd_all_different([A, B, C, D]).

hasValidRows([], []).
hasValidRows([CurrentRow|Rows], [CurrentRowOptions|RowOptions]) :-
    allElementsMatched(CurrentRow, CurrentRowOptions),
    hasValidRows(Rows, RowOptions).
hasValidRows(Rows) :-
    getRowOptions(RowOptions),
    hasValidRows(Rows, RowOptions).

allElementsMatched([], []).
allElementsMatched([Head|Tail], List2)  :-
    member(Head, List2),
    select(Head, List2, Remaining),
    allElementsMatched(Tail, Remaining).

hasValidColumns([]).
hasValidColumns([CurrentColumn|Tail]) :-
    validColumn(CurrentColumn),
    hasValidColumns(Tail).

validColumn([_|[]]) :- !.
validColumn([Head|Tail]) :-
    validate(Head, Tail),
    validColumn(Tail).

validate(_, []) :- !.
validate(X, [Head|Tail]) :-
    validEntry(X, Head),
    validate(X, Tail).

validEntry(X, Y) :- matched(X, Y).
validEntry(X, Y) :- hasConflictingMatch(X, Y), fail.
validEntry(X, Y) :- \+ hasConflictingMatch(X, Y), \+ mismatched(X, Y).

hasConflictingMatch(X, Y) :-
    sameRow(Y, Z),
    matched(X, Z), !.
hasConflictingMatch(X, Y) :-
    sameRow(X, Z),
    matched(Y, Z), !.

sameRow(X, Y) :- row(_, Z),
    member(X, Z),
    member(Y, Z),
    \+ (X = Y).

printGrid([]).
printGrid([Head|Tail]) :-
    print(Head),
    print('\n'),
    printGrid(Tail).