-module(p07).
-export([flatten/1]).

flatten(List) -> p05:reverse(flatten(List, [])).

flatten([H=[_|_]|T], Acc) ->
	flatten(T, flatten(H, Acc));
flatten([[]|T], Acc) ->
	flatten(T, Acc);
flatten([H|T], Acc) ->
	flatten(T, [H|Acc]);
flatten([], Acc) ->
	Acc.

