%%% Yuhang Huang (yh6714) and Jun Yin (jy3414) - 2017.2.14

-module(erb).
-export([start/0]).

start() ->
  receive
    {bind, Beb, App} -> ok
  end,
  next(Beb, App, []).

next(Beb, App, Delivered) ->
  receive
    {rb_broadcast, {From, Msg, Msg_Id}} ->
      Beb ! {beb_broadcast, From, {From, Msg, Msg_Id}},
      next(Beb, App, Delivered);
    {beb_deliver, From, Msg} ->
      case lists:member(Msg, Delivered) of
        true -> next(Beb, App, Delivered);
        false -> 
          App ! {rb_deliver, Msg},
          Beb ! {beb_broadcast, From, Msg},
          next(Beb, App, Delivered ++ [Msg])
      end
  end.

