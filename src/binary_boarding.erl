-module(binary_boarding).
-export([max_seat_id/1, empty_seat/1]).

max_seat_id(Passes) ->
    lists:max(lists:map(fun to_id/1, Passes)).

empty_seat(Passes) ->
    Ids = lists:map(fun to_id/1, Passes),
    Pairs = lists:zip(Ids, lists:duplicate(length(Ids), true)),
    Seats = maps:from_list(Pairs),
    find_empty(Seats).

to_id(Pass) ->
    to_id(Pass, {0, 127}, {0, 7}).

to_id([], {R, R}, {S, S}) -> R * 8 + S;
to_id([$L|Rest], Row, Seat) ->
    to_id(Rest, Row, keep_lower(Seat));
to_id([$R|Rest], Row, Seat) ->
    to_id(Rest, Row, keep_upper(Seat));
to_id([$F|Rest], Row, Seat) ->
    to_id(Rest, keep_lower(Row), Seat);
to_id([$B|Rest], Row, Seat) ->
    to_id(Rest, keep_upper(Row), Seat).

keep_lower({L, U}) ->
    {L, (U - L) div 2 + L}.

keep_upper({L, U}) ->
    {(U - L) div 2 + 1 + L, U}.

find_empty(Seats) ->
    Max = lists:max(maps:values(Seats)),
    find_empty(1, Max, Seats).

find_empty(Max, Max, _Seats) -> false;
find_empty(Pos, Max, Seats) ->
    Prev = maps:get(Pos - 1, Seats, false),
    Cur = maps:get(Pos, Seats, false),
    Next = maps:get(Pos + 1, Seats, false),
    if Prev andalso (not Cur) andalso Next -> Pos;
       true -> find_empty(Pos + 1, Max, Seats)
    end.
