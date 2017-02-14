%%% Yuhang Huang (yh6714) and Jun Yin (jy3414)- 2017.2.12

-module(process).
-export([start/2]).

start(Id, System) ->
  PL = spawn(pl, start, []),
  App = spawn(app, start, [Id, PL]),
  PL ! {bindApp, App},
  System ! {pl, PL}.

 
