-module(toboggan_trajectory_tests).

-include_lib("eunit/include/eunit.hrl").

basic_sample_test() ->
    TestData = load_test_data("3-sample-0.txt"),
    ?assertEqual(7, toboggan_trajectory:tree_hits(format_data(TestData))).

basic_test() ->
    TestData = load_test_data("3.txt"),
    ?assertEqual(167, toboggan_trajectory:tree_hits(format_data(TestData))).

advanced_sample_test() ->
    TestData = load_test_data("3-sample-0.txt"),
    Hits = toboggan_trajectory:tree_hits_advanced(format_data(TestData)),
    ?assertEqual(336, Hits).

advanced_test() ->
    TestData = load_test_data("3.txt"),
    Hits = toboggan_trajectory:tree_hits_advanced(format_data(TestData)),
    ?assertEqual(736527114, Hits).

load_test_data(File) ->
    Path = code:priv_dir(aoc2020) ++ "/test-data/" ++ File,
    {ok, Data} = file:read_file(Path),
    Data.

format_data(Input) ->
    InputString = binary_to_list(Input),
    lists:filter(fun(L) -> length(L) > 0 end,
                 string:split(InputString, "\n", all)).
