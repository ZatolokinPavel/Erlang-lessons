-module(xml).
-export([decode/1]).

decode(String) -> decode(String, no, {<<>>,[],<<>>}).

decode(<<">">>, closeTag, Acc) ->
	Acc;
decode(<<"<", T/binary>>, no, Acc) ->
	decode(T, openTag, Acc);
decode(<<">", T/binary>>, openTag, Acc) ->
	decode(T, content, Acc);
decode(<<"</", T/binary>>, content, Acc) ->
	decode(T, closeTag, Acc);

decode(<<H:1/binary, T/binary>>, openTag, {Tag, [], Cont}) ->
	decode(T, openTag, {<<Tag/binary, H/binary>>, [], Cont});
decode(<<H:1/binary, T/binary>>, content, {Tag, [], Cont}) ->
	decode(T, content, {Tag, [], <<Cont/binary, H/binary>>});
decode(<<_:1/binary, T/binary>>, closeTag, Acc) ->
	decode(T, closeTag, Acc).
