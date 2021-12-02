-module(password_philosophy).
-export([valid/1, valid_advanced/1]).

valid(L) ->
    Fn = fun({{Min, Max}, Char, Str}) ->
                 AllChar = lists:filter(fun(X) -> X =:= Char end, Str),
                 Len = length(AllChar),
                 Len >= Min andalso Len =< Max
         end,
    lists:filter(Fn, L).

valid_advanced(L) ->
    Fn = fun({{P0, P1}, Char, Str}) ->
                 C0 = lists:nth(P0, Str),
                 C1 = lists:nth(P1, Str),
                 (C0 =:= Char orelse C1 =:= Char) andalso C0 =/= C1
         end,
    lists:filter(Fn, L).
