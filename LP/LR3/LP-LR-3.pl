% ЛП-ЛР-3
% Вариант 3
% Железнодорожный сортировочный узел устроен так, как показано на рисунке (см. ЛР-практикум). На левой стороне собрано некоторое число вагонов двух типов (черные и белые), обоих типов по n штук., в произвольном порядке Тупик вмещает все 2n вагонов. Пользуясь тремя сортировочными операциями (слева в тупик, из тупика направо, слева направо, минуя тупик), собрать вагоны на правой стороне, так, чтобы типы чередовались. Для решения задачи достаточно 3n-1 сортировочных операций.

move([H|T],X,T,[H|X]) :- !.

% Продление пути без зацикливания
prolong(Given,Given1,[H|T],[Y,H|T]):-
    move(Given,H,Given1,Y),
    \+ member(Y,[H|T]).

work_DeadEnd([H|T],T,K,[H|K]).


inv_print([]).
inv_print([A|T]):-inv_print(T), write(A), nl.

int(1).
int(X):-
    int(Y),
    X is Y + 1.

% Поиск в глубину
search_deep(A,B) :-
    write('DFS start for': A), nl,
    get_time(DFS_START),
    deep([[]],B,L,[],A),
    inv_print(L),
    get_time(DFS_END),
    write('DFS END'), nl, nl,
    T1 is DFS_END - DFS_START,
    write('DFS time: '), write(T1), nl, nl.

deep([X|T],X,[X|T],_,_):-!.

deep(_,_,_,_,[]):-fail.

deep(P,F,L,Deadend,Strt):-
    prolong(Strt,Strt1,P,P1),deep(P1,F,L,Deadend,Strt1).

deep(P,F,L,Deadend,Strt):-
    work_DeadEnd(Strt,Strt1,Deadend,Deadend1), deep(P,F,L,Deadend1,Strt1).

deep(P,F,L,Deadend,Strt):-
   length(Deadend,Num), Num > 0, prolong(Deadend,Deadend1,P,P1), deep(P1,F,L,Deadend1,Strt).


% Поиск в ширину
search_bridth(X,Y):-
    write('BFS start for': X), nl,
    get_time(BFS_START),
    bridth([[[]]],X,[],Y,L),
    inv_print(L),
    get_time(BFS_END),
    write('BFS END'), nl, nl,
    T1 is BFS_END - BFS_START,
    write('BFS time: '), write(T1), nl, nl.

bridth([[X|T]|_],_,_,X,[X|T]).

bridth(_,[],_,_,_):-fail.

bridth([P|QI],A,Deadend,X,R):-
    (
    prolong(Deadend,Deadend1,P,P1),append(QI,P1,Q0), bridth([Q0],A,Deadend1,X,R);
    prolong(A,A1,P,P1), append(QI,P1,Q0), bridth([Q0],A1,Deadend,X,R);
    work_DeadEnd(A,A1,Deadend,Deadend1), bridth([P|QI],A1,Deadend1,X,R)
    ).

bridth([_|T],A,Deadend,Y,L):-
    bridth(T,A,Deadend,Y,L).


% Поиск с итерационным заглублением
search_id(Start,Finish) :-
    write('ITER start for': Start), nl,
    get_time(ITER_START),
    int(DepthLimit),
    depth_id([[]],Start,[],Finish,Res,DepthLimit),
    inv_print(Res),
    get_time(ITER_END),
    write('ITER END'), nl, nl,
    T1 is ITER_END - ITER_START,
    write('Iteratrion time: '), write(T1), nl, nl.

depth_id([Finish|T],[],_,Finish,[Finish|T],0).

depth_id(P,A,Deadend,Finish,R,N):-
    N > 0,
    (
    prolong(Deadend,Deadend1,P,P1), N1 is N - 1, depth_id(P1,A,Deadend1,Finish,R,N1);
    prolong(A,A1,P,P1),  N1 is N - 1, depth_id(P1,A1,Deadend,Finish,R,N1);
    work_DeadEnd(A,A1,Deadend,Deadend1), depth_id(P,A1,Deadend1,Finish,R,N)
    ).

solve(Start, Finish) :-
    search_deep(Start, Finish),
    search_bridth(Start, Finish),    
	search_id(Start,Finish).
