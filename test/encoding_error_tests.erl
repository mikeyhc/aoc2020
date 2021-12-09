-module(encoding_error_tests).

-include_lib("eunit/include/eunit.hrl").

basic_sample_test() ->
    TestData = format_data(load_test_data("9-sample-0.txt")),
    ?assertEqual(127, encoding_error:find_error(TestData, 5)).

basic_test() ->
    TestData = format_data(load_test_data("9.txt")),
    ?assertEqual(2089807806, encoding_error:find_error(TestData, 25)).

advanced_sample_test() ->
    TestData = format_data(load_test_data("9-sample-0.txt")),
    ?assertEqual(62, encoding_error:contiguous_set(TestData, 5)).

advanced_test() ->
    TestData = format_data(load_test_data("9.txt")),
    ?assertEqual(245848639, encoding_error:contiguous_set(TestData, 25)).

load_test_data(File) ->
    Path = code:priv_dir(aoc2020) ++ "/test-data/" ++ File,
    {ok, Data} = file:read_file(Path),
    Data.

format_data(Input) ->
    InputString = binary_to_list(Input),
    Parts = lists:filter(fun(S) -> S =/= "" end,
                         string:split(InputString, "\n", all)),
    lists:map(fun list_to_integer/1, Parts).
