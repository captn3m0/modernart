/**
 AWARDS
 This file deals with the awards, which gives 2 points
 cumulative score benefit to the artist starting from the round
 the award was played in
 
 There are 5 awards - one per artist
 */
 
% Whether an artist won an award in a given round
array[Rounds,Artists] of var bool: awards_per_round_per_artist;

array[Rounds,Artists] of var int: award_bonus_per_round_per_artist;

% Total number of awards for each artist = 1
constraint forall(a in Artists) ( sum(col(awards_per_round_per_artist,a)) = 1 );

% awards can only be given if an artist's card was played that turn
constraint forall(r in Rounds, a in Artists) (
  awards_per_round_per_artist[r,a] -> cards_per_artist_per_round[r,a] > 0
);

% Set award_bonus_per_round_per_artist = array[5] with bonus that can be added to ranking scores
constraint forall(r in Rounds, a in Artists) (
  award_bonus_per_round_per_artist[r,a] = 
    if awards_per_round_per_artist[r,a] then
      2
   else
     0
   endif
);