%%% Yuhang Huang (yh6714) and Jun Yin (jy3414) - 2017.2.12

-module(process).
-export([start/2]).

start(Id, System) ->
  PL = spawn(pl, start, []),
  Beb = spawn(beb, start, []),
  App = spawn(app, start, [Id]),
  App ! {bind, Beb},
  Beb ! {bind, PL, App},
  PL ! {bind, Beb},
  System ! {pl, PL}.

 
