-module(toboggan_trajectory).
-export([tree_hits/1, tree_hits_advanced/1]).

tree_hits(ListMap) ->
    Map = build_map(ListMap),
    Width = length(hd(ListMap)),
    Height = length(ListMap),
    run_simulation(3, 1, Map, Height, Width).

tree_hits_advanced(ListMap) ->
    Map = build_map(ListMap),
    Width = length(hd(ListMap)),
    Height = length(ListMap),
    Run = fun({R, D}) -> run_simulation(R, D, Map, Height, Width) end,
    Sims = [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}],
    lists:foldl(fun(X, Acc) -> X * Acc end, 1, lists:map(Run, Sims)).

run_simulation(Right, Down, Map, Height, Width) ->
    run_simulation(1, 1, Right, Down, Map, Height, Width, 0).

run_simulation(_X, Y, _R, _D, _Map, H, _W, Hits) when Y > H -> Hits;
run_simulation(X, Y, R, D, Map, H, W, Hits) when X > W ->
    run_simulation(X - W, Y, R, D, Map, H, W, Hits);
run_simulation(X, Y, R, D, Map, H, W, Hits0) ->
    Hits1 = case maps:get({X, Y}, Map) of
                $# -> Hits0 + 1;
                $. -> Hits0
            end,
    run_simulation(X + R, Y + D, R, D, Map, H, W, Hits1).

build_map(Input) ->
    build_map(Input, 1, #{}).

build_map([], _Y, Acc) -> Acc;
build_map([H|T], Y, Acc0) ->
    Acc1 = build_map(H, Y, 1, Acc0),
    build_map(T, Y + 1, Acc1).

build_map([], _Y, _X, Acc) -> Acc;
build_map([H|T], Y, X, Acc) ->
    build_map(T, Y, X + 1, Acc#{{X, Y} => H}).
