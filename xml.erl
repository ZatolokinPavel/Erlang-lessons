-module(xml).
-export([decode/1]).

% Первичное преобразование и самая простая проверка
decode(String) ->
    case{String} of
        {<<>>}  -> error;
        {_}     -> decode(String, {<<>>, [], []})
    end.


% Основное тело программы, где определяются теги и контент
decode(<<"</", T/binary>>, {Tag, Attrib, Content}) ->
    {Bin, {Tag, []}} = tag(T, {<<>>, []}),
    case{Bin == <<>>} of
        {false} -> {Bin, {Tag, Attrib, Content}};
        {true}  -> {Tag, Attrib, Content}
    end;
decode(<<"<", T/binary>>, {<<>>, [], Cont}) ->
    {Bin, {Tag, Att}} = tag(T, {<<>>, []}),
    decode(Bin, {Tag, Att, Cont});
decode(Bin, {Tag, Attrib, []}) ->
    {T, Cont} = content(Bin, <<>>, []),
    decode(T, {Tag, Attrib, Cont}).


% Обработка тегов
tag(<<">", T/binary>>, {Tag, Att}) ->
    {T, {Tag, reverse(Att)}};
tag(<<" ", T/binary>>, {Tag, Acc}) ->
    {Bin, Att} = attribute(T, {<<>>, <<>>}),
    tag(Bin, {Tag, [Att | Acc]});
tag(<<H:1/binary, T/binary>>, {Tag, []}) ->
    tag(T, {<<Tag/binary, H/binary>>, []}).


% Обработка атрибутов тегов
attribute(<<"=\"", H:1/binary, T/binary>>, {Name, <<>>}) ->
    attribute(T, {Name, H});
attribute(<<"\"", T/binary>>, Acc) ->
    {T, Acc};
attribute(<<H:1/binary, T/binary>>, {Name, <<>>}) ->
    attribute(T, {<<Name/binary, H/binary>>, <<>>});
attribute(<<H:1/binary, T/binary>>, {Name, Value}) ->
    attribute(T, {Name, <<Value/binary, H/binary>>}).


% Обработка контента и перенаправление вложений в основную часть
content(<<"</", T/binary>>, <<>>, Cont) ->
    {<<"</", T/binary>>, reverse(Cont)};
content(<<"<", T/binary>>, <<>>, Cont) ->
    {Bin, NextLevel} = decode(<<"<", T/binary>>),
    content(Bin, <<>>, [NextLevel|Cont]);
content(<<"<", T/binary>>, Acc, Cont) ->
    content(<<"<", T/binary>>, <<>>, [Acc|Cont]);
content(<<H:1/binary, T/binary>>, Acc, Cont) ->
    content(T, <<Acc/binary, H/binary>>, Cont).


% Помогает переворачивать списки
reverse(List1) -> reverse(List1,[]).
reverse([], List2) -> List2;
reverse([H|T], List2) -> reverse(T, [H|List2]).

