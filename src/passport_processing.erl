-module(passport_processing).
-export([valid/1, valid_advanced/1]).

valid(Passports) ->
    lists:filter(fun valid_passport/1, Passports).

valid_passport(#{"byr" := _, "iyr" := _, "eyr" := _, "hgt" := _,
                 "hcl" := _, "ecl" := _, "pid" := _}) ->
    true;
valid_passport(_) -> false.

valid_advanced(Passports) ->
    lists:filter(fun valid_passport_fields/1, Passports).

valid_passport_fields(#{"byr" := Byr, "iyr" := Iyr, "eyr" := Eyr, "hgt" := Hgt,
                        "hcl" := Hcl, "ecl" := Ecl, "pid" := Pid}) ->
    valid_byr(Byr) andalso
    valid_iyr(Iyr) andalso
    valid_eyr(Eyr) andalso
    valid_hgt(Hgt) andalso
    valid_hcl(Hcl) andalso
    valid_ecl(Ecl) andalso
    valid_pid(Pid);
valid_passport_fields(_) -> false.

valid_byr(Year) -> Year >= 1920 andalso Year =< 2002.
valid_iyr(Year) -> Year >= 2010 andalso Year =< 2020.
valid_eyr(Year) -> Year >= 2020 andalso Year =< 2030.

valid_hgt({V, cm}) -> V >= 150 andalso V =< 193;
valid_hgt({V, in}) -> V >= 59 andalso V =< 76;
valid_hgt(_) -> false.

valid_hcl([$#|Rest]) ->
    length(Rest) =:= 6 andalso valid_hex(Rest);
valid_hcl(_) -> false.

valid_ecl(V) ->
    lists:member(V, ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]).

valid_pid(Pid) when length(Pid) =:= 9 ->
    try
        _ = list_to_integer(Pid),
        true
    catch
        _:_ -> false
    end;
valid_pid(_Pid) -> false.

valid_hex([]) -> true;
valid_hex([H|T]) ->
    case lists:member(H, "0123456789abcdef") of
        true -> valid_hex(T);
        false -> false
    end.
