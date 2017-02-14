%%% Yuhang Huang (yh6714) and Jun Yin (jy3414) - 2017.2.13

-module(lossypl).
-export([start/0]).

start() ->
  receive
    {bind, Beb} -> ok
  end,
  Reliability = 100,
  next(Beb, Reliability).

next(Beb, Reliability) ->
  RandomNumber = random:uniform(100),
  receive
    {pl_deliver, From, Msg} -> 
      Beb ! {pl_deliver, From, Msg};
    {pl_send, Dst, From, Msg} -> 
      if
        RandomNumber =< Reliability -> Dst ! {pl_deliver, From, Msg};
        true -> ok
      end
  end,
  next(Beb, Reliability).

