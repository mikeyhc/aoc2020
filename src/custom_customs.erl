-module(custom_customs).
-export([answer_sum/1, intersection_sum/1]).

answer_sum(Answers) ->
    Size = fun(A) -> sets:size(sets:from_list(lists:flatten(A))) end,
    lists:sum(lists:map(Size, Answers)).

intersection_sum(Answers) ->
    lists:sum(lists:map(fun find_union/1, Answers)).

find_union(Answers) ->
    sets:size(sets:intersection(lists:map(fun sets:from_list/1, Answers))).
