%  AWARDS
%  This file deals with the awards, which gives 2 points
%  cumulative score benefit to the artist starting from the round
%  the award was played in
%  There are 5 awards - one per artist
%  The awards can be given to any artist
%  The net result of this code should be to increase awards_per_round_per_artist[r,a]
%  by 2 for every award that a gets in round r.


include "globals.mzn";

% This is what we export
array[Rounds,Artists] of var {0,2,4,6,8,10}: award_bonus_per_round_per_artist;

% Covered better in Symbols
% TODO: Remove after consideration?
% awards can only be given if an artist's card was played that turn
constraint forall(r in Rounds, a in Artists) (
  AwardPlayedInRound[a] = r /\ AwardGiven[a] -> CardsForArtist[r,a] > 0
);

% Which ROUND was this award played in
array[Artists] of var Rounds: AwardPlayedInRound;
array[Artists] of var Artists: AwardedArtist;
% The above 2 should be good, but we need to account for the cases
% where the award was not given at all. 
array[Artists] of var bool: AwardGiven;

constraint forall(r in Rounds, a in Artists) (
  award_bonus_per_round_per_artist[r,a] = 
    2 * 
      % Gives us a list of true/false
      sum(aa in Artists) (if AwardPlayedInRound[aa] = r /\ AwardGiven[aa] /\ AwardedArtist[aa] = a then true else false endif)
);
