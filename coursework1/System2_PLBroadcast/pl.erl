%%% Yuhang Huang (yh6714) and Jun Yin (jy3414) - 2017.2.13

-module(pl).
-export([start/0]).

start() ->
  receive
    {bindApp, App} -> ok
  end,
  receive 
    {neighbour, Neighbours} -> ok
  end,
  next(App, Neighbours).

next(App, Neighbours) ->
  receive
    {pl_deliver, From, Msg} -> App ! {pl_deliver, From, Msg};
    {pl_send, From, Msg} -> [ PL ! {pl_deliver, From, Msg} || PL <- Neighbours ]
  end,
  next(App, Neighbours).

