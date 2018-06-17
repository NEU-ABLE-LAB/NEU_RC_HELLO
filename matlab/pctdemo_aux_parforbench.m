function S = pctdemo_aux_parforbench(numHands, numPlayers, n)
%PCTDEMO_AUX_PARFORBENCH Use parfor to play blackjack.
%   S = pctdemo_aux_parforbench(numHands, numPlayers, n) plays 
%   numHands hands of blackjack numPlayers times, and uses no 
%   more than n MATLAB(R) workers for the computations.

%   Copyright 2007-2009 The MathWorks, Inc.

S = zeros(numHands, numPlayers);
parfor (i = 1:numPlayers, n)
    S(:, i) = pctdemo_task_blackjack(numHands, 1);
end
