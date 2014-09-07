-module(xml).
-export([decode/1, tag/2]).

decode(String) -> decode(String, {[], [], <<>>}).

decode(<<"</", T/binary>>, {Tag, Next, Cont}) ->
    {Bin, _} = tag(T, [<<>>]),
    case{Bin == <<>>} of
        {false} -> {Bin, {Tag, Next, Cont}};
        {true}  -> {Tag, Next, Cont}
    end;
decode(<<"<", T/binary>>, {[], [], Cont}) ->
    {Bin, Tag} = tag(T, [<<>>]),
    decode(Bin, {Tag, [], Cont});
decode(<<"<", T/binary>>, {Tag, Next, Cont}) ->
    {TT, NextLevel} = decode(<<"<", T/binary>>, {[], [], <<>>}),
    decode(TT, {Tag, [NextLevel|Next], Cont});
decode(Bin, {Tag, Next, _}) ->
    {T, Cont} = content(Bin, <<>>),
    decode(T, {Tag, Next, Cont}).

tag(<<">", T/binary>>, Acc) ->
    {T, reverse(Acc)};
tag(<<" ", T/binary>>, Acc) ->
    {Bin, Att} = attribute(T, {<<>>, <<>>}),
    tag(Bin, [Att | Acc]);
tag(<<H:1/binary, T/binary>>, [Acc]) ->
    tag(T, [<<Acc/binary, H/binary>>]).

attribute(<<"=\"", H:1/binary, T/binary>>, {Name, <<>>}) ->
    attribute(T, {Name, H});
attribute(<<"\"", T/binary>>, Acc) ->
    {T, Acc};
attribute(<<H:1/binary, T/binary>>, {Name, <<>>}) ->
    attribute(T, {<<Name/binary, H/binary>>, <<>>});
attribute(<<H:1/binary, T/binary>>, {Name, Value}) ->
    attribute(T, {Name, <<Value/binary, H/binary>>}).

content(<<"<", T/binary>>, Acc) ->
    {<<"<", T/binary>>, Acc};
content(<<H:1/binary, T/binary>>, Acc) ->
    content(T, <<Acc/binary, H/binary>>).


reverse(List1) -> reverse(List1,[]).
reverse([], List2) -> List2;
reverse([H|T], List2) -> reverse(T, [H|List2]).

