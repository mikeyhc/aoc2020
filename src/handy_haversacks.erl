-module(handy_haversacks).
-export([contains_gold/1, inner_bags/1]).

contains_gold(RuleLines) ->
    Rules = build_ruletable(RuleLines),
    length(lists:filter(fun(X) -> can_gold(X, Rules) end,
                        maps:values(Rules))).

inner_bags(RuleLines) ->
    Rules = build_ruletable(RuleLines),
    count_inner_bags("shiny gold", Rules).

build_ruletable(RuleLines) ->
    lists:foldl(fun add_rule/2, #{}, RuleLines).

add_rule(RuleLine, Table) ->
    {Key, Value} = parse_rule_line(RuleLine),
    Table#{Key => Value}.

parse_rule_line(Line) ->
    Parts = string:split(Line, " ", all),
    [Descriptor, Color, _Bags, "contain"|Rest] = Parts,
    {Descriptor ++ " " ++ Color, parse_inner(Rest, [])}.

parse_inner(["no", "other", "bags."], _Acc) -> [];
parse_inner([Number, Descriptor, Color, _Bags], Acc) ->
    [{Descriptor ++ " " ++ Color, list_to_integer(Number)}|Acc];
parse_inner([Number, Descriptor, Color, _Bags|Rest], Acc) ->
    Entry = {Descriptor ++ " " ++ Color, list_to_integer(Number)},
    parse_inner(Rest, [Entry|Acc]).

can_gold(Rules, Table) ->
    HasGold = fun({"shiny gold", _}) -> true;
                 (_) -> false
              end,
    case lists:search(HasGold, Rules) of
        {value, _} -> true;
        false ->
            Expanded = expand_rules(Rules, Table),
            if Expanded =:= [] -> false;
                true -> can_gold(Expanded, Table)
            end
    end.

expand_rules(Rules, Table) ->
    Expanded = lists:foldl(fun(V, Acc) -> expand_rule(V, Acc, Table) end,
                           #{}, Rules),
    maps:to_list(Expanded).

expand_rule({Type, Number}, Rules, Table) ->
    NewRules = lists:map(fun({K, V}) -> {K, V * Number} end,
                         maps:get(Type, Table)),
    Fold = fun({K, V0}, Acc) ->
                   maps:update_with(K, fun(V1) -> V0 + V1 end, V0, Acc)
           end,
    lists:foldl(Fold, Rules, NewRules).

count_inner_bags(Bag, Rules) ->
    SumChildren = fun({K, V}, Acc) ->
                          Acc + V + V * count_inner_bags(K, Rules)
                  end,
    lists:foldl(SumChildren, 0, maps:get(Bag, Rules)).
