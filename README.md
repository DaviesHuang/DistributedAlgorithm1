# DistributedAlgorithm1

Introduction:

This project contains 6 system implementations written in Erlang for the Distributed Algorithm course.

How to execute system 1-6:

Navigate to the corresponding system directory e.g. cd System1_ErlangBroadcast 
Execute Makefile to run the system, e.g. make run

How to modify execution parameters:

Number of messages: change variable Max_messages in start() function in 
systemN.erl (N = 1..6). 

Timeout for completion of task1: change variable Timeout in start() function in systemN.erl (N = 1..6).

Reliability value: change variable Reliability in start() function in 
lossypl.erl.

Timeout to use to terminate process 3: In start(Id) function in app.erl, change the first argument of "Id == 3 -> erlang:send_after(100, self(), timeout);" e.g. 100 to 5