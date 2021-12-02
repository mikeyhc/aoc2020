-module(report_repair).
-export([find_2020/1, find_2020_advanced/1]).

find_2020([]) -> false;
find_2020([H|T]) ->
    case find_2020(H, T) of
        false -> find_2020(T);
        V -> V
    end.

find_2020(_, []) -> false;
find_2020(V, [H|_]) when V + H =:= 2020 -> {V, H};
find_2020(V, [_|T]) -> find_2020(V, T).

find_2020_advanced([]) -> false;
find_2020_advanced([_]) -> false;
find_2020_advanced([A,B|T]) ->
    case find_2020_advanced(A, [B|T]) of
        false -> find_2020_advanced([B|T]);
        V -> V
    end.

find_2020_advanced(_, []) -> false;
find_2020_advanced(A, [B|T]) ->
    case find_2020_advanced(A, B, T) of
        false -> find_2020_advanced(A, T);
        V -> V
    end.

find_2020_advanced(_, _, []) -> false;
find_2020_advanced(A, B, [C|_]) when A + B + C =:= 2020 -> {A, B, C};
find_2020_advanced(A, B, [_|T]) -> find_2020_advanced(A, B, T).
