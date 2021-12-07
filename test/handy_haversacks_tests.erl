-module(handy_haversacks_tests).

-include_lib("eunit/include/eunit.hrl").

basic_sample_test() ->
    TestData = format_data(load_test_data("7-sample-0.txt")),
    ?assertEqual(4, handy_haversacks:contains_gold(TestData)).

basic_test() ->
    TestData = format_data(load_test_data("7.txt")),
    ?assertEqual(355, handy_haversacks:contains_gold(TestData)).

advanced_sample_test() ->
    TestData = format_data(load_test_data("7-sample-0.txt")),
    ?assertEqual(32, handy_haversacks:inner_bags(TestData)).

advanced_test() ->
    TestData = format_data(load_test_data("7.txt")),
    ?assertEqual(5312, handy_haversacks:inner_bags(TestData)).

load_test_data(File) ->
    Path = code:priv_dir(aoc2020) ++ "/test-data/" ++ File,
    {ok, Data} = file:read_file(Path),
    Data.

format_data(Input) ->
    InputString = binary_to_list(Input),
    lists:filter(fun(S) -> S =/= "" end,
                 string:split(InputString, "\n", all)).
