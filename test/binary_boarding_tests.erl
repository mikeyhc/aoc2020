-module(binary_boarding_tests).

-include_lib("eunit/include/eunit.hrl").

basic_sample_test() ->
    TestData = format_data(load_test_data("5-sample-0.txt")),
    ?assertEqual(820, binary_boarding:max_seat_id(TestData)).

basic_test() ->
    TestData = format_data(load_test_data("5.txt")),
    ?assertEqual(861, binary_boarding:max_seat_id(TestData)).

advanced_sample_test() ->
    % no data provided
    ?assertEqual(true, true).

advanced_test() ->
    TestData = format_data(load_test_data("5.txt")),
    ?assertEqual(633, binary_boarding:empty_seat(TestData)).

load_test_data(File) ->
    Path = code:priv_dir(aoc2020) ++ "/test-data/" ++ File,
    {ok, Data} = file:read_file(Path),
    Data.

format_data(Input) ->
    InputString = binary_to_list(Input),
    lists:filter(fun(S) -> S =/= "" end,
                 string:split(InputString, "\n", all)).
