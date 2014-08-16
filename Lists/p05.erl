-module(p05).
-export([reverse/1]).

reverse(List) -> reversing(List,[]).

reversing([], List2) ->
	List2;
reversing([H|T], List2) ->
	reversing(T, [H|List2]).
	
