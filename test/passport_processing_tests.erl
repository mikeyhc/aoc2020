-module(passport_processing_tests).

-include_lib("eunit/include/eunit.hrl").

basic_sample_test() ->
    TestData = format_data(load_test_data("4-sample-0.txt")),
    ?assertEqual(2, length(passport_processing:valid(TestData))).

basic_test() ->
    TestData = format_data(load_test_data("4.txt")),
    ?assertEqual(237, length(passport_processing:valid(TestData))).

advanced_sample_test() ->
    TestData = format_data(load_test_data("4-sample-1.txt")),
    ?assertEqual(4, length(passport_processing:valid_advanced(TestData))).

advanced_test() ->
    TestData = format_data(load_test_data("4.txt")),
    ?assertEqual(172, length(passport_processing:valid_advanced(TestData))).

load_test_data(File) ->
    Path = code:priv_dir(aoc2020) ++ "/test-data/" ++ File,
    {ok, Data} = file:read_file(Path),
    Data.

format_data(Input) ->
    InputString = binary_to_list(Input),
    build_passports(string:split(InputString, "\n", all)).

build_passports(Parts) ->
    Fn = fun("", {Current, Acc}) -> {[], [build_passport(Current)|Acc]};
            (Line, {Current, Acc}) -> {Line ++ " " ++ Current, Acc}
         end,
    {Last, Passports} = lists:foldl(Fn, {"", []}, Parts),
    [build_passport(Last)|Passports].

build_passport(Line) ->
    Fn = fun([A,B,C,$:|V]) -> {[A,B,C], V} end,
    Pairs = lists:map(Fn, lists:filter(fun(X) -> X =/= "" end,
                                       string:split(Line, " ", all))),
    Map = maps:from_list(Pairs),
    maps:map(fun convert_field/2, Map).

convert_field("byr", V) -> list_to_integer(V);
convert_field("iyr", V) -> list_to_integer(V);
convert_field("eyr", V) -> list_to_integer(V);
convert_field("hgt", V) -> height_converion(V);
convert_field(_, V) -> V.

height_converion(Hgt) ->
    height_converion(Hgt, "").

height_converion([], Acc) -> Acc;
height_converion("in", Acc) ->
    {list_to_integer(Acc), in};
height_converion("cm", Acc) ->
    {list_to_integer(Acc), cm};
height_converion([H|T], Acc) ->
    height_converion(T, Acc ++ [H]).
