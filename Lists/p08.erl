-module(p08).
-export([compress/1]).

compress(List) -> p05:reverse(compress(List, [])).

compress([], List)->
	List;
compress([H|T], [H|List])->
	compress(T, [H|List]);
compress([H|T], List)->
	compress(T, [H|List]).
