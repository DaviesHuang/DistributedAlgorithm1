%%% Yuhang Huang(yh6714) and Jun Yin (jy3414) - 2017.2.13

-module(beb).
-export([start/0]).

start() ->
  receive
    {bind, PL, Erb} -> ok
  end,
  receive
    {pl_deliver, _, {neighbour, Neighbours}} -> ok
  end,
  next(PL, Erb, Neighbours).

next(PL, Erb, Neighbours) ->
  receive
    {pl_deliver, From, Msg} -> 
      Erb ! {beb_deliver, From, Msg};
    {beb_broadcast, From, Msg} -> 
      [ PL ! {pl_send, Dst, From, Msg} || Dst <- Neighbours ]
  end,
  next(PL, Erb, Neighbours).
