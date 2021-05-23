calculate([N], N) :- number(N).
calculate(Expr, Ans) :- append(A, [-|B], Expr), calculate(A, X), calculate(B, Y), !, Ans is X - Y.
calculate(Expr, Ans) :- append(A, [+|B], Expr), calculate(A, X), calculate(B, Y), !, Ans is X + Y.
calculate(Expr, Ans) :- append(A, [*|B], Expr), calculate(A, X), calculate(B, Y), !, Ans is X * Y.
calculate(Expr, Ans) :- append(A, [/|B], Expr), calculate(A, X), calculate(B, Y), !, Y \= 0, Ans is X / Y.
calculate(Expr, Ans) :- append(A, [^|B], Expr), calculate(A, X), calculate(B, Y), !, Ans is X ** Y.
