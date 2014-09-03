-module(xml).
-export([decode/1]).

decode(String) -> decode(String, {<<>>,[],<<>>}).

decode(<<"</", _/binary>>, Acc) ->
	Acc;
decode(<<"<", T/binary>>, {_, [], Cont}) ->
    {Bin, Tag} = tag(T, <<>>),
	decode(Bin, {Tag, [], Cont});
decode(Bin, {Tag, [], _}) ->
    {T, Cont} = content(Bin, <<>>),
	decode(T, {Tag, [], Cont}).

tag(<<">", T/binary>>, Acc) ->
    {T, Acc};
tag(<<H:1/binary, T/binary>>, Acc) ->
    tag(T, <<Acc/binary, H/binary>>).

content(<<"<", T/binary>>, Acc) ->
    {<<"<", T/binary>>, Acc};
content(<<H:1/binary, T/binary>>, Acc) ->
    content(T, <<Acc/binary, H/binary>>).
