%%% Yuhang Huang (yh6714) and Jun Yin (jy3414) - 2017.2.12

-module(process).
-export([start/2]).

start(Id, System) ->
  PL = spawn(lossypl, start, []),
  Beb = spawn(beb, start, []),
  Erb = spawn(erb, start, []),
  App = spawn(app, start, [Id]),
  App ! {bind, Erb},
  Beb ! {bind, PL, Erb},
  PL ! {bind, Beb},
  Erb ! {bind, Beb, App},
  System ! {pl, PL}.

 
