%%% Yuhang Huang (yh6714) and Jun Yin (jy3414) - 2017.2.12

-module(system3).
-export([start/0]).

start() ->
  N = 5,
  Max_messages = 0,
  Timeout = 1000,
  [ spawn(process, start, [Id, self()]) || Id <- lists:seq(1, N) ],
  List = receive_pl(N, []),
  [ PL ! {pl_deliver, self(), {neighbour, List}} || PL <- List ],
  [ PL ! {pl_deliver,self(),{task1,start,Max_messages,Timeout}} || PL <- List ].

receive_pl(N, List) ->
  if 
    N == 0 -> List;
    true -> 
      receive 
        {pl, PL} -> receive_pl(N-1, List ++ [PL])
      end
  end.

