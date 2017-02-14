%%% Yuhang Huang (yh6714) and Jun Yin (jy3414) - 2017.2.12

-module(system1).
-export([start/0]).

start() ->
  N = 5,
  Max_messages = 1000,
  Timeout = 3000,
  List = spawn_process(lists:seq(1, N), []),
  [ begin Process ! {neighbour, List} end || Process <- List ],
  [ begin Process ! {task1,start,Max_messages,Timeout} end || Process <- List ].

spawn_process([], List) -> List;
spawn_process([H|T], List) ->
  spawn_process(T, [spawn(process, start, [H])|List]).



