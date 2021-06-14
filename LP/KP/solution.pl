:- consult('facts.pl').

% Задание 3
% Предикаты для поиска родственников
% Поиск золовки

% father(child, father)
father(X, Y) :- male(Y), child(X, Y).

% grandfather(person, grandfather)
grandfather(X, Y) :- child(X, Z), father(Z, Y).

% greatgrandfather(person, greatgrandfather)
greatgrandfather(X, Y) :- child(X, Z), grandfather(Z, Y).

% greatgreatgrandfather(person, greatgreatgrandfather)
greatgreatgrandfather(X, Y) :- child(X, Z), greatgrandfather(Z, Y).

% mother(child, mother)
mother(X, Y) :- female(Y), child(X, Y).

% grandmother(person, grandmother)
grandmother(X, Y) :- child(X, Z), mother(Z, Y).

% greatgrandmother(person, greatgrandmother)
greatgrandmother(X, Y) :- child(X, Z), grandmother(Z, Y).

% greatgreatgrandmother(person, greatgreatgrandmother)
greatgreatgrandmother(X, Y) :- child(X, Z), greatgrandmother(Z, Y).

% brother(person, brother).
brother(X, Y) :- male(Y), child(Y, Z), child(X, Z), X \= Y.

% sister(person, sister).
sister(X, Y) :- female(Y), child(Y, Z), child(X, Z), X \= Y.

% son(parent, son)
son(X, Y) :- male(Y), child(Y, X).

% grandson(granddad, grandson)
grandson(X, Y) :- child(Z, X), son(Z, Y).

% greatgrandson(greatgranddad, greatgrandson)
greatgrandson(X, Y) :- child(Z, X), grandson(Z, Y).

% greatgreatgrandson(greatgreatgranddad, greatgreatgrandson)
greatgreatgrandson(X, Y) :- child(Z, X), greatgrandson(Z, Y).

% daughter(parent, daughter)
daughter(X, Y) :- female(Y), child(Y, X).

% granddaughter(granddaughter, granddaughter)
granddaughter(X, Y) :- child(Z, X), daughter(Z, Y).

% greatgranddaughter(greatgranddaughter, greatgranddaughter)
greatgranddaughter(X, Y) :- child(Z, X), granddaughter(Z, Y).

% greatgreatgranddaughter(greatgreatgranddaughter, greatgreatgranddaughter)
greatgreatgranddaughter(X, Y) :- child(Z, X), greatgranddaughter(Z, Y).

% husband(wife, husband)
husband(X, Y) :- wife(Y, X).

% wife(husband, wife)
wife(X, Y) :-  male(X), female(Y), child(Z, X), child(Z, Y).

% uncle(person, uncle)
uncle(X, Y) :- child(X, Z), brother(Z, Y).

% aunt(person, aunt)
aunt(X, Y) :- child(X, Z), sister(Z, Y).

% nephew(person, nephew)
nephew(X, Y) :- male(Y), child(Y, Z), child(Z, W), child(X, W), Z \= X.

% niece(person, niece)
niece(X, Y) :- female(Y), child(Y, Z), child(Z, W), child(X, W), Z \= X.

% cousin(person, cousin)
cousin(X, Y) :- uncle(X, Z), child(Y, Z).
cousin(X, Y) :- aunt(X, Z), child(Y, Z).

% sister_in_law(woman, her sister in law)
sister_in_law(X, Y) :- female(X), female(Y), husband(X, Z), sister(Z, Y).

% Задание 4
% Степень родства
% Итеративный поиск 
relate(X, Y) :- for(Cur_Depth, 1, 2), iter(X, Y, Path, Cur_Depth), print_path(Path).

% Поиск с лимитом
iter(Start, Finish, Path, DepthLimit) :- path_iter([Start], Finish, Path, DepthLimit).

% Результат на текущей глубине
path_iter([Finish | Path], Finish, [Finish | Path], 0).

path_iter(Cur_Path, Finish, Path, Depth) :- Depth > 0, prolong(Cur_Path, New_Path),
                                                        New_Depth is Depth - 1,
                                                        path_iter(New_Path, Finish, Path, New_Depth).

prolong([Cur_Pos | Tail], [New_Pos, Cur_Pos | Tail]) :- move(Cur_Pos, New_Pos, _), 
                                                    not(member(New_Pos, [Cur_Pos | Tail])).

for(A, A, _).
for(X, A, B) :- A < B, A1 is A + 1, for(X, A1, B).

% Все возможные расстановки для алгоритма
move(Cur, Next, greatgreatgrandfather) :- greatgreatgrandfather(Cur, Next).
move(Cur, Next, greatgrandfather) :- greatgrandfather(Cur, Next).
move(Cur, Next, grandfather) :- grandfather(Cur, Next).
move(Cur, Next, father) :- father(Cur, Next).
move(Cur, Next, greatgreatgrandmother) :- greatgreatgrandmother(Cur, Next).
move(Cur, Next, greatgrandmother) :- greatgrandmother(Cur, Next).
move(Cur, Next, grandmother) :- grandmother(Cur, Next).
move(Cur, Next, mother) :- mother(Cur, Next).
move(Cur, Next, son) :- son(Cur, Next).
move(Cur, Next, grandson) :- grandson(Cur, Next).
move(Cur, Next, greatgrandson) :- greatgreatgrandson(Cur, Next).
move(Cur, Next, greatgreatgrandson) :- greatgreatgrandson(Cur, Next).
move(Cur, Next, daughter) :- daughter(Cur, Next).
move(Cur, Next, granddaughter) :- granddaughter(Cur, Next).
move(Cur, Next, greatgranddaughter) :- greatgreatgranddaughter(Cur, Next).
move(Cur, Next, greatgreatgranddaughter) :- greatgreatgranddaughter(Cur, Next).
move(Cur, Next, brother) :- brother(Cur, Next).
move(Cur, Next, sister) :- sister(Cur, Next).
move(Cur, Next, uncle) :- uncle(Cur, Next).
move(Cur, Next, aunt) :- aunt(Cur, Next).
move(Cur, Next, nephew) :- nephew(Cur, Next).
move(Cur, Next, niece) :- niece(Cur, Next).
move(Cur, Next, cousin) :- cousin(Cur, Next).
move(Cur, Next, husband) :- husband(Cur, Next).
move(Cur, Next, wife) :- wife(Cur, Next).
move(Cur, Next, sister_in_law) :- sister_in_law(Cur, Next).

% Вывод результат 
print_path([Head1, Head2]) :- move(Head2, Head1, Relationship), !, write(Relationship), nl.
print_path([Head1, Head2 | Tail]) :- move(Head2, Head1, Relationship), !, write(Relationship), write(' of '),
                                        print_path([Head2 | Tail]).

% TASK 5
% Естественно-языковой интерфейс

% Разделение списка на части
split(List, Part1, Part2) :- append(Part1, Part2, List), not(length(Part1, 0)), not(length(Part2, 0)).
split(List, Part1, Part2, Part3) :- append(Part1, TMP, List), append(Part2, Part3, TMP),
                                    not(length(Part1, 0)), not(length(Part2, 0)), not(length(Part3, 0)).


% Набор вопросов
questions_list(['How many', 'Who is', 'Is', 'how many', 'who is', 'is']).

% Перевод множественных в единственные% Перевод множественных в единственные
plural('greatgreatgrandfathers', 'greatgreatgrandfather').
plural('greatgrandfathers', 'greatgrandfather').
plural('grandfathers', 'grandfather').
plural('greatgreatgrandmothers', 'greatgreatgrandmother').
plural('greatgrandmothers', 'greatgrandmother').
plural('grandmothers', 'grandmother').

plural('brothers', 'brother').
plural('sisters', 'sister').

plural('sons', 'son').
plural('grandsons', 'grandson').
plural('greatgrandsons', 'greatgrandson').
plural('greatgreatgrandsons', 'greatgreatgrandson').
plural('daughters', 'daughter').
plural('granddaughters', 'granddaughter').
plural('greatgranddaughters', 'greatgranddaughter').
plural('greatgreatgranddaughters', 'greatgreatgranddaughter').

plural('uncles', 'uncle').
plural('aunts', 'aunt').

plural('nephews', 'nephew').
plural('nieces', 'niece').

plural('cousins', 'cousin').

% Есть ли имя в базе
check_name(Name) :- male(Name).
check_name(Name) :- female(Name).

check_relative(Relationship) :- move(_, _, Relationship), !.
check_question(Question) :- questions_list(List), member(Question, List).

% Разделение фразы на вопрос и семантическую группу
check_phrase([Question | Other], X) :- check_question(Question), check_semantic_part(Other, X).

% Вопросы "How much"
check_semantic_part([Head | Tail], X) :- plural(Head, Head1), check_relative(Head1), split(Tail, _, [Part2 | _]),
                                            check_name(Part2), !, append([Head1], [Part2], X).

% Вопросы "Is" 
check_semantic_part([Head | Tail], X) :- check_name(Head), split(Tail, [Part1, "'s" | _], [Part2 | _]),
                                        check_name(Part1), check_relative(Part2), !,
                                        append([Head], [Part1], Tmp), append(Tmp, [Part2], X).

% Вопросы "Who is" 
check_semantic_part([Head | Tail], X) :- check_name(Head), split(Tail, _, [Part2 | _]), check_relative(Part2),
                                            !, append([Head], [Part2], X).

ask(X, Y) :- check_phrase(X, DS), analyze(DS, Y).

check(Relationship, Name1, Name2) :- move(Name2, Name1, Relationship).

% "Is" вопрос
analyze(DS, _) :- DS = [Name1, Name2, Relate], check(Relate, Name1, Name2).

% "Who is" вопрос
analyze(DS, Y) :- DS = [Name, Relationship], check_name(Name), check_relative(Relationship),
                    check(Relationship, Y, Name).

% "How many" вопрос
analyze(DS, Y) :- DS = [Relationship, Name], check_name(Name), check_relative(Relationship),
                setof(X, check(Relationship, X, Name), List), length(List, Y).
