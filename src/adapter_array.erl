-module(adapter_array).
-export([joltage_differance/1, configurations/1]).

joltage_differance(Joltages) ->
    Diff = fun(V0, {V1, {Ones, Twos, Threes}}) ->
                   case V0 - V1 of
                       1 -> {V0, {Ones + 1, Twos, Threes}};
                       2 -> {V0, {Ones, Twos + 1, Threes}};
                       3 -> {V0, {Ones, Twos, Threes + 1}}
                   end
           end,
    {_, Output} = lists:foldl(Diff, {0, {0, 0, 1}},
                              lists:sort(Joltages)),
    Output.

configurations(Joltages) ->
    Max = lists:max(Joltages),
    count_configurations(Max, sets:from_list(Joltages), #{Max + 3 => 1}).

count_configurations(0, _Joltages, Map) ->
    maps:get(1, Map, 0) + maps:get(2, Map, 0) + maps:get(3, Map, 0);
count_configurations(I, Joltages, Map) ->
    case sets:is_element(I, Joltages) of
        false -> count_configurations(I - 1, Joltages, Map);
        true ->
            A = maps:get(I + 3, Map, 0),
            B = maps:get(I + 2, Map, 0),
            C = maps:get(I + 1, Map, 0),
            count_configurations(I - 1, Joltages, Map#{I => A + B + C})
    end.
