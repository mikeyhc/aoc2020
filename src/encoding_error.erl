-module(encoding_error).
-export([find_error/2, contiguous_set/2]).

find_error(Data, PreambleLength) ->
    {Preamble, Rest} = lists:split(PreambleLength, Data),
    find_error_(Preamble, Rest).

find_error_(Preamble=[_|T], [V|Rest]) ->
    case can_sum(V, Preamble) of
        true -> find_error_(T ++ [V], Rest);
        false -> V
    end.

can_sum(_, []) -> false;
can_sum(V, [H|T]) when H >= V -> can_sum(V, T);
can_sum(V, [H|T]) ->
    case lists:search(fun(X) -> X + H =:= V end, T) of
        {value, _} -> true;
        false -> can_sum(V, T)
    end.

contiguous_set(Data, PreambleLength) ->
    Error = find_error(Data, PreambleLength),
    Set = find_set(Error, Data),
    lists:max(Set) + lists:min(Set).

find_set(_Error, []) -> false;
find_set(_Error, [_]) -> false;
find_set(Error, [A,B|T]) ->
    case find_set(Error, [A,B], T) of
        false -> find_set(Error, [B|T]);
        {true, L} -> L
    end.

find_set(_Value, _Set, []) -> false;
find_set(Value, Set, [H|T]) ->
    Sum = lists:sum(Set),
    if Sum =:= Value -> {true, Set};
       Sum > Value -> false;
       Sum < Value -> find_set(Value, [H|Set], T)
    end.
