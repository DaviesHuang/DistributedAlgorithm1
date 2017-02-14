%%% Yuhang Huang (yh6714) and Jun Yin (jy3414) - 2017.2.13

-module(app).
-export([start/1]).

start(Id) ->
  receive
    {bind, Erb} -> ok
  end,
  Received = maps:from_list([ {Q, 0} || Q <- lists:seq(1,5) ]),
  receive 
    {rb_deliver, {task1, start, Max_messages, Timeout}} -> 
      if 
        Id == 3 -> erlang:send_after(100, self(), timeout);
        true -> erlang:send_after(Timeout, self(), timeout)
      end,
      io:format("App ~p received start task~n", [Id]),
      broadcast_msg(Id, Erb, Max_messages, 0, Received, 1)
  end.

broadcast_msg(Id, Erb, Max_messages, Messages_sent, Received, Msg_Id) ->
  receive 
    {rb_deliver, {Sender, msg, _}} -> 
      No_receive = maps:get(Sender, Received),
      Received_new = maps:update(Sender, No_receive + 1, Received),
      broadcast_msg(Id, Erb, Max_messages, Messages_sent, Received_new, Msg_Id);
    timeout ->
      Output = [ {Messages_sent, Value} || Value <- maps:values(Received) ],
      io:format("~p: ~w~n", [Id, Output])
  after 
    0 ->
      if
        (Messages_sent < Max_messages) or (Max_messages == 0) -> 
          Erb ! {rb_broadcast, {Id, msg, Msg_Id}},
          broadcast_msg(Id,Erb,Max_messages,Messages_sent+1,Received,Msg_Id+1);
        true -> broadcast_msg(Id,Erb,Max_messages,Messages_sent,Received,Msg_Id)
      end
  end.
 

