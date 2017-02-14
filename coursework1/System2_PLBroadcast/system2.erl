%%% Yuhang Huang (yh6714) and Jun Yin (jy3414)- 2017.2.12

-module(system2).
-export([start/0]).

start() ->
  N = 5,
  Max_messages = 100,
  Timeout = 1000,
  spawn_process(lists:seq(1, N), []),
  List = receive_pl(N, []),
  [ PL ! {neighbour, List} || PL <- List ],
  [ PL ! {pl_deliver,self(),{task1,start,Max_messages,Timeout}} || PL <- List ].

spawn_process([], List) -> List;
spawn_process([H|T], List) ->
  spawn_process(T, [spawn(process, start, [H, self()])|List]).

receive_pl(N, List) ->
  if 
    N == 0 -> List;
    true -> 
      receive 
        {pl, PL} -> receive_pl(N-1, List ++ [PL])
      end
  end.

