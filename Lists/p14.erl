-module(p14).
-export([duplicate/1]).

duplicate(List) -> duplicate(List, []).

duplicate([H|T], Acc) ->
	duplicate(T, [H,H|Acc]);
% Всё закончено, списки пусты - выводим
duplicate([], Acc)->
	p05:reverse(Acc).

