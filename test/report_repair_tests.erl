-module(report_repair_tests).

-include_lib("eunit/include/eunit.hrl").

basic_sample_test() ->
    TestData = load_test_data("1-sample-0.txt"),
    {X, Y} = report_repair:find_2020(format_data(TestData)),
    ?assertEqual(514579, X * Y).

basic_test() ->
    TestData = load_test_data("1.txt"),
    {X, Y} = report_repair:find_2020(format_data(TestData)),
    ?assertEqual(440979, X * Y).

advanced_sample_test() ->
    TestData = load_test_data("1-sample-0.txt"),
    {X, Y, Z} = report_repair:find_2020_advanced(format_data(TestData)),
    ?assertEqual(241861950, X * Y * Z).

advanced_test() ->
    TestData = load_test_data("1.txt"),
    {X, Y, Z} = report_repair:find_2020_advanced(format_data(TestData)),
    ?assertEqual(82498112, X * Y * Z).

load_test_data(File) ->
    Path = code:priv_dir(aoc2020) ++ "/test-data/" ++ File,
    {ok, Data} = file:read_file(Path),
    Data.

format_data(Input) ->
    InputString = binary_to_list(Input),
    Parts = lists:filter(fun(L) -> length(L) > 0 end,
                         string:split(InputString, "\n", all)),
    lists:map(fun list_to_integer/1, Parts).
