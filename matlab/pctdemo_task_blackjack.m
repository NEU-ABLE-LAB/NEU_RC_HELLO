function [S, exeTime] = pctdemo_task_blackjack(N, numTimes)
%PCTDEMO_TASK_BLACKJACK  Simulate blackjack.
%   S = pctdemo_task_blackjack(N, numTimes)
%   plays N hands of blackjack numTimes times, and returns a N-by-numTimes
%   matrix of results.

%   Copyright 2007-2011 The MathWorks, Inc.

    start = tic;
    S = zeros(N, numTimes);
    for i = 1:numTimes
        S(:, i) = iPlayBlackjack(N);
    end
    exeTime = toc(start);
end % End of pctdemo_task_blackjack.
       
function S = iPlayBlackjack(N)
% Simulate a single player playing N hands.
%#ok<*AGROW>: ignore warnings about growing arrays - this is deliberate
    S = zeros(N, 1);
    bet = 10;
    for n = 1:N
       bet1 = bet;
       P = iDeal();         % Player's hand.
       D = iDeal();         % Dealer's hand.
       P = [P iDeal()];
       D = [D -iDeal()];    % Hide dealer's hole card.
          
       % Split pairs.
       split = mod(P(1), 13) == mod(P(2), 13);
       if split 
          split = iPair(iValue(P(1)), iValue(D(1)));
       end
       if split
          P2 = P(2);
          P = [P(1) iDeal()];
          bet2 = bet1;
       end
          
       % Play player's hand(s).
       [P, bet1] = iPlayHand(P, D, bet1);
       if split
          P2 = [P2 iDeal()];
          [P2, bet2] = iPlayHand(P2, D, bet2);
       end
          
       % Play dealer's hand.
       D(2) = -D(2);     % Reveal dealer's hole card.
       while iValue(D) <= 16
          D = [D iDeal()];
       end
          
       % Calculate the payoff.
       s = iPayoff(P, D, split, bet1);
       if split
          s = s + iPayoff(P2, D, split, bet2);
       end
       S(n) = s;
    end
end % End of pctdemo_task_blackjack.

function c = iDeal()
% Deal one card.

    persistent deck ncards
    if isempty(deck) || ncards <  6
       % Shuffle four decks.
       deck = [1:52 1:52 1:52 1:52];
       ncards = length(deck);
       deck = deck(randperm(ncards));
    end
    c = deck(ncards);
    ncards = ncards - 1;
end % End of iDeal.

function v = iValueHard(X)
% Evaluate hand.
    X = mod(X - 1, 13) + 1;
    X = min(X, 10);
    v = sum(X);
end % End of iValueHard.

function v = iValue(X)
% Evaluate hand.
    X = mod(X - 1, 13) + 1;
    X = min(X, 10);
    v = sum(X);
    % Promote soft ace
    if any(X == 1) && v <= 11
       v = v + 10;
    end
end % End of iValue.

function [P, bet] = iPlayHand(P, D, bet)
% Play player's hand.

    while iValue(P) < 21
       % 0 = stand
       % 1 = hit
       % 2 = double down
       if any(mod(P, 13) == 1) && iValueHard(P) <= 10
          strat = iSoft(iValue(P)-11, iValue(D(1)));
       else
          strat = iHard(iValue(P), iValue(D(1)));
       end
       if length(P) > 2 && strat == 2
          strat = 1;
       end
       switch strat
           case 0
              break
           case 1
              P = [P iDeal];
           case 2
              % Double down.
              % Double bet and get one more card.
              bet = 2*bet;
              P = [P iDeal];
              break
           otherwise
              break
       end
    end
end % End of iPlayHand.

function s = iPayoff(P, D, split, bet)
% Returns the payoff.
    valP = iValue(P);
    valD = iValue(D);
    if valP == 21 && length(P) == 2 && ...
       ~(valD == 21 && length(D) == 2) && ~split
       s = 1.5*bet;
    elseif valP > 21
       s = -bet;
    elseif valD > 21
       s = bet;
    elseif valD > valP
       s = -bet;
    elseif valD < valP
       s = bet;
    else
       s = 0;
    end
end % End of iPayoff.

function strat = iHard(p, d)
% Strategy for hands without aces.
% strategy = iHard(player's_total, dealer's_upcard)

% 0 = stand
% 1 = hit
% 2 = double down

    persistent HARD
    if isempty(HARD)
       n = NaN; % Not possible.
       % Dealer shows:
       %      2 3 4 5 6 7 8 9 T A
       HARD = [ ...
          1   n n n n n n n n n n
          2   1 1 1 1 1 1 1 1 1 1
          3   1 1 1 1 1 1 1 1 1 1
          4   1 1 1 1 1 1 1 1 1 1
          5   1 1 1 1 1 1 1 1 1 1
          6   1 1 1 1 1 1 1 1 1 1
          7   1 1 1 1 1 1 1 1 1 1
          8   1 1 1 1 1 1 1 1 1 1
          9   2 2 2 2 2 1 1 1 1 1
         10   2 2 2 2 2 2 2 2 1 1
         11   2 2 2 2 2 2 2 2 2 2
         12   1 1 0 0 0 1 1 1 1 1
         13   0 0 0 0 0 1 1 1 1 1
         14   0 0 0 0 0 1 1 1 1 1
         15   0 0 0 0 0 1 1 1 1 1
         16   0 0 0 0 0 1 1 1 1 1
         17   0 0 0 0 0 0 0 0 0 0
         18   0 0 0 0 0 0 0 0 0 0
         19   0 0 0 0 0 0 0 0 0 0
         20   0 0 0 0 0 0 0 0 0 0];
    end
    strat = HARD(p, d);
end % End of iHard.

function strat = iSoft(p, d)
% Strategy array for hands with aces.
% strategy = iSoft(player's_total, dealer's_upcard)

% 0 = stand
% 1 = hit
% 2 = double down

    persistent SOFT
    if isempty(SOFT)
       n = NaN; % Not possible.
       % Dealer shows:
       %      2 3 4 5 6 7 8 9 T A
       SOFT = [ ...
          1   n n n n n n n n n n
          2   1 1 2 2 2 1 1 1 1 1
          3   1 1 2 2 2 1 1 1 1 1
          4   1 1 2 2 2 1 1 1 1 1
          5   1 1 2 2 2 1 1 1 1 1
          6   2 2 2 2 2 1 1 1 1 1
          7   0 2 2 2 2 0 0 1 1 0
          8   0 0 0 0 0 0 0 0 0 0
          9   0 0 0 0 0 0 0 0 0 0];
    end
    strat = SOFT(p, d);
end % End of iSoft.

function strat = iPair(p, d)
% Strategy for splitting pairs.
% strategy = iPair(paired_card, dealer's_upcard)

% 0 = keep pair
% 1 = split pair

    persistent PAIR
    if isempty(PAIR)
       n = NaN; % Not possible.
       % Dealer shows:
       %      2 3 4 5 6 7 8 9 T A
       PAIR = [ ...
          1   n n n n n n n n n n
          2   1 1 1 1 1 1 0 0 0 0
          3   1 1 1 1 1 1 0 0 0 0
          4   0 0 0 1 0 0 0 0 0 0
          5   0 0 0 0 0 0 0 0 0 0
          6   1 1 1 1 1 1 0 0 0 0
          7   1 1 1 1 1 1 1 0 0 0
          8   1 1 1 1 1 1 1 1 1 1
          9   1 1 1 1 1 0 1 1 0 0
         10   0 0 0 0 0 0 0 0 0 0
         11   1 1 1 1 1 1 1 1 1 1];
    end
    strat = PAIR(p, d);
end % End of iPair.
