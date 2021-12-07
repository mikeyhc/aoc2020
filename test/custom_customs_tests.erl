-module(custom_customs_tests).

-include_lib("eunit/include/eunit.hrl").

basic_sample_test() ->
    TestData = format_data(load_test_data("6-sample-0.txt")),
    ?assertEqual(11, custom_customs:answer_sum(TestData)).

basic_test() ->
    TestData = format_data(load_test_data("6.txt")),
    ?assertEqual(6504, custom_customs:answer_sum(TestData)).

advanced_sample_test() ->
    TestData = format_data(load_test_data("6-sample-0.txt")),
    ?assertEqual(6, custom_customs:intersection_sum(TestData)).

advanced_test() ->
    TestData = format_data(load_test_data("6.txt")),
    ?assertEqual(3351, custom_customs:intersection_sum(TestData)).

load_test_data(File) ->
    Path = code:priv_dir(aoc2020) ++ "/test-data/" ++ File,
    {ok, Data} = file:read_file(Path),
    Data.

format_data(Input) ->
    InputString = binary_to_list(Input),
    build_customs(string:split(InputString, "\n", all)).

build_customs(Parts) ->
    Fn = fun("", {Current, Acc}) -> {[], [Current|Acc]};
            (Line, {Current, Acc}) -> {[Line|Current], Acc}
         end,
    {Last, Passports} = lists:foldl(Fn, {"", []}, Parts),
    lists:filter(fun(V) -> V =/= [] end, [Last|Passports]).
