-module(p12).
-export([decode_modified/1]).

decode_modified(List) -> decodemod(List, []).

% Если остался последний элемент в кортеже, то кортеж нужно будет удалить
decodemod([{1,X}|T], List) ->
	decodemod(T, [X|List]);
% Рабочий режим
decodemod([{N,X}|T], List) ->
	decodemod([{N-1,X}|T], [X|List]);
% Если не было кортежа, а торчал лишь один элемент
decodemod([X|T], List) ->
	decodemod(T, [X|List]);
% Всё закончено, списки пусты - выводим
decodemod([], List)->
	p05:reverse(List).

