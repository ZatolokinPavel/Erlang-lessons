-module(xml).
-export([decode/1]).

decode(String) -> decode(String, {<<>>, [], <<>>}).

decode(<<"</", T/binary>>, {Tag, Next, Cont}) ->
    {Bin, Tag} = tag(T, <<>>),
    case{Bin == <<>>} of
        {false} -> {Bin, {Tag, Next, Cont}};
        {true}  -> {Tag, Next, Cont}
    end;
decode(<<"<", T/binary>>, {<<>>, [], Cont}) ->
    {Bin, Tag} = tag(T, <<>>),
	decode(Bin, {Tag, [], Cont});
decode(<<"<", T/binary>>, {Tag, Next, Cont}) ->
    {TT, NextLevel} = decode(<<"<", T/binary>>, {<<>>, [], <<>>}),
    decode(TT, {Tag, [NextLevel|Next], Cont});
decode(Bin, {Tag, Next, _}) ->
    {T, Cont} = content(Bin, <<>>),
	decode(T, {Tag, Next, Cont}).

tag(<<">", T/binary>>, Acc) ->
    {T, Acc};
tag(<<H:1/binary, T/binary>>, Acc) ->
    tag(T, <<Acc/binary, H/binary>>).

content(<<"<", T/binary>>, Acc) ->
    {<<"<", T/binary>>, Acc};
content(<<H:1/binary, T/binary>>, Acc) ->
    content(T, <<Acc/binary, H/binary>>).
