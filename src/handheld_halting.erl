-module(handheld_halting).
-export([loop_acc_value/1, fixed_acc_value/1]).

loop_acc_value(Instr) ->
    Map = maps:from_list(lists:zip(lists:seq(0, length(Instr) - 1), Instr)),
    {true, Acc} = find_loop(Map),
    Acc.

find_loop(Map) ->
    find_loop(Map, sets:new(), 0, 0).

find_loop(Map, Seen, Idx0, Acc0) ->
    case maps:is_key(Idx0, Map) of
        true ->
            case sets:is_element(Idx0, Seen) of
                true -> {true, Acc0};
                false ->
                    {Idx1, Acc1} = run_instr(maps:get(Idx0, Map), Idx0, Acc0),
                    find_loop(Map, sets:add_element(Idx0, Seen), Idx1, Acc1)
            end;
        false -> {false, Acc0}
    end.

fixed_acc_value(Instr) ->
    Length = length(Instr) - 1,
    Map = maps:from_list(lists:zip(lists:seq(0, Length), Instr)),
    find_fixed(Map, 0, Length).

find_fixed(_Map, Max, Max) -> false;
find_fixed(Map0, Pos, Max) ->
    case swap_op(Map0, Pos) of
        {true, Map1} ->
            case find_loop(Map1) of
                {false, Acc} -> Acc;
                {true, _Acc} -> find_fixed(Map0, Pos + 1, Max)
            end;
        false -> find_fixed(Map0, Pos + 1, Max)
    end.

run_instr({"nop", _}, Idx, Acc) -> {Idx + 1, Acc};
run_instr({"acc", V}, Idx, Acc) -> {Idx + 1, Acc + V};
run_instr({"jmp", V}, Idx, Acc) -> {Idx + V, Acc}.

swap_op(Map, Pos) ->
    swap_op(maps:get(Pos, Map), Map, Pos).

swap_op({"nop", V}, Map, Pos) -> {true, Map#{Pos => {"jmp", V}}};
swap_op({"jmp", V}, Map, Pos) -> {true, Map#{Pos => {"nop", V}}};
swap_op(_, _Map, _Pos) -> false.
