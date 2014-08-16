-module(p06).
-export([is_palindrome/1]).

is_palindrome(List) ->
	Reverse = p05:reverse(List),
	Reverse =:= List.
