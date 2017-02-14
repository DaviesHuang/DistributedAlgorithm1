%%% Yuhang Huang (yh6714) and Jun Yin (jy3414) - 2017.2.12

-module(process).
-export([start/1]).

start(Id) ->
  receive 
    {neighbour, Neighbours} -> ok
  end,
  Received = maps:from_list([ {Q, 0} || Q <- lists:seq(1,5) ]),
  receive 
    {task1, start, Max_messages, Timeout} -> 
      erlang:send_after(Timeout, self(), timeout),
      broadcast_msg(Id, Max_messages, 0, Neighbours, Received)
  end.


broadcast_msg(Id, Max_messages, Messages_sent, Neighbours, Received) ->
  receive 
    {msg, Sender} ->
      No_receive = maps:get(Sender, Received),
      Received_new = maps:update(Sender, No_receive + 1, Received), 
      broadcast_msg(Id, Max_messages, Messages_sent, Neighbours, Received_new);
    timeout -> 
      Output = [ {Messages_sent, Value} || Value <- maps:values(Received) ],
      io:format("~p: ~w~n", [Id, Output])
  after 
    0 ->
      if
        (Messages_sent < Max_messages) or (Max_messages == 0) -> 
          [ begin Neighbour ! {msg, Id} end || Neighbour <- Neighbours ],
          broadcast_msg(Id, Max_messages, Messages_sent+1,Neighbours, Received);
        true -> 
          broadcast_msg(Id, Max_messages, Messages_sent, Neighbours, Received)
      end
  end.
  
