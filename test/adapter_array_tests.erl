-module(adapter_array_tests).

-include_lib("eunit/include/eunit.hrl").

basic_sample_test() ->
    TestData0 = format_data(load_test_data("10-sample-0.txt")),
    {Ones0, _, Threes0} = adapter_array:joltage_differance(TestData0),
    ?assertEqual(35, Ones0 * Threes0),
    TestData1 = format_data(load_test_data("10-sample-1.txt")),
    {Ones1, _, Threes1} = adapter_array:joltage_differance(TestData1),
    ?assertEqual(220, Ones1 * Threes1).

basic_test() ->
    TestData = format_data(load_test_data("10.txt")),
    {Ones, _, Threes} = adapter_array:joltage_differance(TestData),
    ?assertEqual(1876, Ones * Threes).

advanced_sample_test() ->
    TestData0 = format_data(load_test_data("10-sample-0.txt")),
    ?assertEqual(8, adapter_array:configurations(TestData0)),
    TestData1 = format_data(load_test_data("10-sample-1.txt")),
    ?assertEqual(19208, adapter_array:configurations(TestData1)).

advanced_test() ->
    TestData = format_data(load_test_data("10.txt")),
    ?assertEqual(14173478093824, adapter_array:configurations(TestData)).

load_test_data(File) ->
    Path = code:priv_dir(aoc2020) ++ "/test-data/" ++ File,
    {ok, Data} = file:read_file(Path),
    Data.

format_data(Input) ->
    InputString = binary_to_list(Input),
    Parts = lists:filter(fun(S) -> S =/= "" end,
                         string:split(InputString, "\n", all)),
    lists:map(fun list_to_integer/1, Parts).
