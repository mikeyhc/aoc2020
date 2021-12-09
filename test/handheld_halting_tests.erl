-module(handheld_halting_tests).

-include_lib("eunit/include/eunit.hrl").

basic_sample_test() ->
    TestData = format_data(load_test_data("8-sample-0.txt")),
    ?assertEqual(5, handheld_halting:loop_acc_value(TestData)).

basic_test() ->
    TestData = format_data(load_test_data("8.txt")),
    ?assertEqual(2051, handheld_halting:loop_acc_value(TestData)).

advanced_sample_test() ->
    TestData = format_data(load_test_data("8-sample-0.txt")),
    ?assertEqual(8, handheld_halting:fixed_acc_value(TestData)).

advancede_test() ->
    TestData = format_data(load_test_data("8.txt")),
    ?assertEqual(2304, handheld_halting:fixed_acc_value(TestData)).

load_test_data(File) ->
    Path = code:priv_dir(aoc2020) ++ "/test-data/" ++ File,
    {ok, Data} = file:read_file(Path),
    Data.

format_data(Input) ->
    InputString = binary_to_list(Input),
    Parts = lists:filter(fun(S) -> S =/= "" end,
                         string:split(InputString, "\n", all)),
    lists:map(fun format_line/1, Parts).

format_line(Line) ->
    [Op, Arg] = string:split(Line, " "),
    {Op, list_to_integer(Arg)}.
