% Score a player gets in each given round
array[Rounds,Players] of var int: RoundScore;

% Final score of a player
array[Players] of var int: Score;

% For Cumulative Scoring
% Score = ranking_score + award_score if an award was given this round
constraint forall(r in Rounds, a in Artists) (
  total_score_per_round_per_artist[r,a] = 
    ranking_score_per_artist_per_round[r,a] + award_bonus_per_round_per_artist[r,a] + 
    if r=Round1 then 
      0 
    else 
      total_score_per_round_per_artist[enum_prev(Rounds, r),a] endif
);

% Calculate total score per player

% 1. Per Round
constraint forall(r in Rounds, p in Players) (
  RoundScore[r,p] = sum(a in Artists) (
    visible_count_per_round_per_artist_per_player[r,p,a] * ranking_score_per_artist_per_round[r,a]
  )
);

% 2. For the whole game
constraint forall(p in Players) (
  Score[p] = sum(r in Rounds) (RoundScore[r,p])
);
