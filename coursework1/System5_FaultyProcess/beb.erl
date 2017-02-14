%%% Yuhang Huang(yh6714) and Jun Yin (jy3414) - 2017.2.13

-module(beb).
-export([start/0]).

start() ->
  receive
    {bind, PL, App} -> ok
  end,
  receive
    {pl_deliver, _, {neighbour, Neighbours}} -> ok
  end,
  next(PL, App, Neighbours).

next(PL, App, Neighbours) ->
  receive
    {pl_deliver, From, Msg} -> 
      App ! {beb_deliver, From, Msg};
    {beb_broadcast, From, Msg} -> 
      [ PL ! {pl_send, Dst, From, Msg} || Dst <- Neighbours ]
  end,
  next(PL, App, Neighbours).
