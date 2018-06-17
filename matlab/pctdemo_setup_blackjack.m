function [fig, numHands, numPlayers] = pctdemo_setup_blackjack(difficulty)
%PCTDEMO_SETUP_BLACKJACK Performs the initialization for the Parallel
%Computing  Toolbox Blackjack examples.
%
%   [fig, numHands, numPlayers] = pctdemo_setup_blackjack(difficulty) returns
%    the output figure, the number of players and the number of hands that each 
%   player should play.

%   Copyright 2007-2017 The MathWorks, Inc.

    % In Blackjack, face cards count 10 points, aces count one or 11 points,
    % all other cards count their face value.  The objective is to reach,
    % but not exceed, 21 points.  If you go over 21, or "bust", before the
    % dealer, you lose your bet on that hand.  If you have 21 on the first
    % two cards, and the dealer does not, this is "blackjack" and is worth
    % 1.5 times the bet.  If your first two cards are a pair, you may "split"
    % the pair by doubling the bet and use the two cards to start two
    % independent hands.  You may "double down" after seeing the first two
    % cards by doubling the bet and receiving just one more card.
    % "Hit" and "draw" mean take another card.  "Stand" means stop drawing.
    % "Push" means the two hands have the same total.
    %
    % The first mathematical analysis of Blackjack was published in 1956
    % by Baldwin, Cantey, Maisel and McDermott. Their basic strategy, which
    % is also described in many more recent books, makes Blackjack very
    % close to a fair game.  With basic strategy, the expected win or loss
    % per hand is less than one percent of the bet.  The key idea is to
    % avoid going bust before the dealer.  The dealer must play a fixed
    % strategy, hitting on 16 or less and standing on 17 or more.  Since
    % almost one-third of the cards are worth 10 points, you can compare
    % your hand with the dealer's under the assumption that the dealer's
    % hole card is a 10.  If the dealer's up card is a six or less, she
    % must draw.  Consequently, the strategy has you stand on any total over
    % 11 when the deader is showing a six or less.  Split aces and split 8's.
    % Do not split anything else.  Double down with 11, or with 10 if the
    % dealer is showing a six or less.  The complete basic strategy is
    % defined by three arrays, HARD, SOFT and SPLIT, in the code.
    %
    % A more elaborate strategy, called "card counting", can provide a
    % definite mathematical advantage.  Card counting players keep track
    % of the cards that have appeared in previous hands, and use that
    % information to alter both the bet and the play as the deck becomes
    % depleted.  Our simulation does not involve card counting.
    %
    %
    %   From "Numerical Computing with MATLAB"
    %   Cleve Moler
    %   The MathWorks, Inc.
    %   See https://www.mathworks.com/moler
    %   March 1, 2004.  Copyright 2004-2005.
    
    
    fig = pDemoFigure();
    clf(fig);
    set(fig, 'Visible', 'off');
    set(fig, 'Name', 'Blackjack');   
 
    numHands = 2e4;
    numPlayers = 6;
    minPlayers = 1;
    numPlayers = max(minPlayers, round(numPlayers*difficulty));
end % End of pctdemo_setup_blackjack.
