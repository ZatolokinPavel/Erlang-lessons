-module(p01).
-export([last/1]).

last([_]=X)->
	X;
last([_|T])->
	last(T).
