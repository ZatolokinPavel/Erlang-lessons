-module(p03).
-export([element_at/2]).

element_at([H|_],1)->
	H;
element_at([_|T], I)->
	element_at(T, I-1);
element_at([],_)->
	undefined.
