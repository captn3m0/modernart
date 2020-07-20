% This file maintains common symbol constraints
% Since we are modelling each symbol individually (and not "on-a-card"), this results in 
% symbol counts being calculated in isolation.
% Sanity constraints on each symbol file individually ensure
% that atleast one card of the symbol was played by the correct played
% they do not ensure that across symbols
% and hence, the same card may end up getting counted twice for different symbols.
% this file prevents such issues
% and may ultimately end up replacing separate symbol counters

constraint forall(r in Rounds, a in Artists) (
  % Total number of cards played by all players
  % MINUS total number of Draw One Cards played by all players
  sum (p in Players) (
    visible_count_per_round_per_artist_per_player[r,p,a] - DrawOneCard[r,p,a]
  )
  % MINUS total number of awards given this round
   - (if AwardPlayedInRound[a] = r /\ AwardGiven[a] then 1 else 0 endif)
  % Is the number of Symbol Cards played this turn
  % and it can't be negative
  >= 0
);