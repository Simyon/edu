:- consult('facts.pl').

% Задание 3
% Предикаты для поиска родственников
% Поиск золовки

% father(child, father)
father(X, Y) :- male(Y), child(X, Y).

% mother(child, mother)
mother(X, Y) :- female(Y), child(X, Y).

% brother(person, brother).
brother(X, Y) :- male(Y), child(Y, Z), child(X, Z), X \= Y.

% sister(person, sister).
sister(X, Y) :- female(Y), child(Y, Z), child(X, Z), X \= Y.

% grandfather(person, grandfather)
grandfather(X, Y) :- child(X, Z), father(Z, Y).

% grandmother(person, grandmother)
grandmother(X, Y) :- child(X, Z), mother(Z, Y).

% son(parent, son)
son(X, Y) :- male(Y), child(Y, X).

% daughter(parent, daughter)
daughter(X, Y) :- female(Y), child(Y, X).

% husband(wife, husband)
husband(X, Y) :- wife(Y, X).

% wife(husband, wife)
wife(X, Y) :-  male(X), female(Y), child(Z, X), child(Z, Y).

% uncle(person, uncle)
uncle(X, Y) :- child(X, Z), brother(Z, Y).

% aunt(person, aunt)
aunt(X, Y) :- child(X, Z), sister(Z, Y).

% cousin(person, cousin)
cousin(X, Y) :- uncle(X, Z), child(Y, Z).
cousin(X, Y) :- aunt(X, Z), child(Y, Z).

% sister_in_law(woman, her sister in law)
sister_in_law(X, Y) :- female(X), female(Y), husband(X, Z), sister(Z, Y).

% Задание 4
% Степень родства
relative(father, X, Y) :- father(X, Y).
relative(mother, X, Y) :-  mother(X, Y).
relative(brother, X, Y) :- brother(X, Y).
relative(sister, X, Y) :- sister(X, Y).
relative(son, X, Y) :- son(X, Y).
relative(daughter, X, Y) :- daughter(X, Y).
relative(grandfather, X, Y) :- grandfather(X, Y).
relative(grandmother, X, Y) :- grandmother(X, Y).
relative(husband, X, Y) :- husband(X, Y).
relative(wife, X, Y) :- wife(X, Y).
relative(uncle, X, Y) :- uncle(X, Y).
relative(aunt, X, Y) :- aunt(X, Y).
relative(cousin, X, Y) :- cousin(X, Y).
relative(sister_in_law, X, Y) :- sister_in_law(X, Y).


perm(X, Y) :- relative(_, X, Y).
prlng([X|T], [Y, X|T]) :- perm(X, Y), not(member(Y, [X|T])).

bfs([[H|T]|_], H, [H|T]).
bfs([H|T], RES, TREE) :- 
    findall(W, prlng(H, W), TREES), 
    append(T, TREES, NEWTREES), !, bfs(NEWTREES, RES, TREE).

find([_], R, R).
find([X,Y|T], R, REL) :- 
    relative(RE, X, Y), 
    find([Y|T], 
    [RE|R], REL).

relate(REL, X, Y) :- 
    bfs([[X]], Y, R), 
    reverse(R, RE), 
    find(RE, [], NEWREL), 
    reverse(NEWREL, REL), 
    N is 0.

% Задание 5
% Естественно-языковой интерфейс
word(X) :- member(X, [whose, "Whose"]).
have(X) :- member(X, [is, "Is"]).
have_lst([X], REL) :- member(X, [REL]).
question_word(X) :-  member(X, ['?']).
prev_set(NAME) :- nb_setval(name, NAME).
word_prev(X) :- member(X,["His",his,"Him",him,"Her",her,"She",she,"He",he]),!.
to_word(X) :- member(X, ["to", to]).


%1
question(L) :- 
    L = [IS, NAME_0, REL, NAME_1, Q], 
    have(IS), 
    relate(X, NAME_0, NAME_1),
    !, 
    have_lst(X, REL),
    question_word(Q), 
    write(NAME_0),  
    write(" is "),  
    write(REL),  
    write(" "),  
    write(NAME_1), 
    write(".").

%2
question(L) :- 
    L = [WHOSE, REL, IS, NAME, Q], 
    word(WHOSE), 
    relative(REL, NAME, ANS), 
    have(IS), 
    question_word(Q),
    write(NAME), 
    write(" is "),  
    write(REL), 
    write(" "), 
    write(ANS), 
    write("."), 
    prev_set(NAME), 
    nl.

%3
question(L) :- 
    L = [NAME_0, REL, TO, NAME_1, Q], 
    word_prev(NAME_0), 
    nb_getval(name, NAME_2), 
    relate(X, NAME_2, NAME_1),
    !,
    have_lst(X, REL),
    to_word(TO), 
    question_word(Q), 
    write(NAME_2),  
    write(" is "),  
    write(REL),  
    write(" "),  
    write(NAME_1), 
    write(".").
