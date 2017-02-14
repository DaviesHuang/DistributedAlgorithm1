%%% Yuhang Huang (yh6714) and Jun Yin (jy3414) - 2017.2.13

-module(pl).
-export([start/0]).

start() ->
  receive
    {bind, Beb} -> ok
  end,
  next(Beb).

next(Beb) ->
  receive
    {pl_deliver, From, Msg} -> Beb ! {pl_deliver, From, Msg};
    {pl_send, Dst, From, Msg} -> Dst ! {pl_deliver, From, Msg}
  end,
  next(Beb).

