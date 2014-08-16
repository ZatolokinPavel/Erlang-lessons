-module(p13).
-export([decode/1]).

decode(List) -> decode(List, []).

% Если остался последний элемент в кортеже, то кортеж нужно будет удалить
decode([{1,X}|T], List) ->
	decode(T, [X|List]);
% Рабочий режим
decode([{N,X}|T], List) ->
	decode([{N-1,X}|T], [X|List]);
% Всё закончено, списки пусты - выводим
decode([], List)->
	p05:reverse(List).

