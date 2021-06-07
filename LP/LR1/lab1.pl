% Нахождение длины списка
lengthSimon([], 0).
lengthSimon([_|Tail], Length) :- length(Tail, Length1), Length is Length1 + 1.

% Принадлежность элемента списку 
memberSimon(element, list).
memberSimon(Element, [Element|_]).
memberSimon(Element, [_|Tail]) :- memberSimon(Element, Tail).

% Конкатенация списков
appendSimon([], List, List).
appendSimon([Head|Tail], List2, [Head|ResList2]) :- appendSimon(Tail, List2, ResList2).

% Удаление из списка
removeSimon(X, [X|T], T).
removeSimon(X, [H|T], [H|T1]) :- removeSimon(X, T, T1).

% Перестановка
permuteSimon([], []).
permuteSimon(List1, [X|P]) :- removeSimon(X, List1, List2), permuteSimon(List2, P).

% Подсписок в списке
sublistSimon([], _).
sublistSimon([H|T], [H|L1]) :-
    sublistSimon(T, L1).
sublistSimon([H|T], [_|L1]) :-
    sublistSimon([H|T], L1).

% Ревёрс через свои предикаты
reversePSimon([],[]).
reversePSimon([H|T],R) :- reversePSimon(T,RevT),appendSimon(RevT,[H],R).

% Ревёрс через стандартные предикаты
reverseAcc([H|T],A,ResX) :- reverseAcc(T,[H|A],ResX).
reverseAcc([],A,A).
reverseSSimon(X,ResX) :- reverseAcc(X,[],ResX).

% Максимум списка без стандартных предикатов
maxListSimon([X],X) :- !, true.
maxListSimon([X|Xs], M):- maxListSimon(Xs, M), M >= X.
maxListSimon([X|Xs], X):- maxListSimon(Xs, M), X >  M.
