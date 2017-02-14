%%% Yuhang Huang (yh6714) and Jun Yin (jy3414)- 2017.2.13

-module(app).
-export([start/2]).

start(Id, PL) ->
  Received = maps:from_list([ {Q, 0} || Q <- lists:seq(1,5) ]),
  receive 
    {pl_deliver, _, {task1, start, Max_messages, Timeout}} ->
      erlang:send_after(Timeout, self(), timeout), 
      broadcast_msg(Id, PL, Max_messages, 0, Received)
  end.

broadcast_msg(Id, PL, Max_messages, Messages_sent, Received) ->
  receive 
    {pl_deliver, Sender, msg} -> 
      No_receive = maps:get(Sender, Received),
      Received_new = maps:update(Sender, No_receive + 1, Received),
      broadcast_msg(Id, PL, Max_messages, Messages_sent, Received_new);
    timeout -> 
      Output = [ {Messages_sent, Value} || Value <- maps:values(Received) ],
      io:format("~p: ~w~n", [Id, Output]) 
  after 
    0 ->
      if
        (Messages_sent < Max_messages) or (Max_messages == 0) -> 
          PL ! {pl_send, Id, msg},
          broadcast_msg(Id, PL, Max_messages, Messages_sent + 1, Received);
        true -> broadcast_msg(Id, PL, Max_messages, Messages_sent, Received)
      end
  end.
 

