-module(p15).
-export([replicate/2]).

replicate(List, N) -> replicate(List, N, N, []).

replicate([H|T], N, 1, List) ->
	replicate(T, N, N, [H|List]);
replicate([H|T], N, I, List) ->
	replicate([H|T], N, I-1, [H|List]);
% Всё закончено, списки пусты - выводим
replicate([], _, _, List)->
	p05:reverse(List).
