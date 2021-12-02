-module(password_philosophy_tests).

-include_lib("eunit/include/eunit.hrl").

basic_sample_test() ->
    TestData = load_test_data("2-sample-0.txt"),
    Valid = password_philosophy:valid(format_data(TestData)),
    ?assertEqual(2, length(Valid)).

basic_test() ->
    TestData = load_test_data("2.txt"),
    Valid = password_philosophy:valid(format_data(TestData)),
    ?assertEqual(636, length(Valid)).

advanced_sample_test() ->
    TestData = load_test_data("2-sample-0.txt"),
    Valid = password_philosophy:valid_advanced(format_data(TestData)),
    ?assertEqual(1, length(Valid)).

advanced_test() ->
    TestData = load_test_data("2.txt"),
    Valid = password_philosophy:valid_advanced(format_data(TestData)),
    ?assertEqual(588, length(Valid)).

load_test_data(File) ->
    Path = code:priv_dir(aoc2020) ++ "/test-data/" ++ File,
    {ok, Data} = file:read_file(Path),
    Data.

format_data(Input) ->
    InputString = binary_to_list(Input),
    Parts = lists:filter(fun(L) -> length(L) > 0 end,
                         string:split(InputString, "\n", all)),
    Fn = fun(S) ->
                 [Range, [Char|_], String] = string:split(S, " ", all),
                 [Min, Max] = string:split(Range, "-"),
                 {{list_to_integer(Min), list_to_integer(Max)}, Char, String}
         end,
    lists:map(Fn, Parts).
