% Score = ranking_score + award_score if an award was given this round
constraint forall(r in Rounds, a in Artists) (
  total_score_per_round_per_artist[r,a] = 
    ranking_score_per_artist_per_round[r,a] + award_bonus_per_round_per_artist[r,a]
);

% Calculate total score per player

% 1. Per Round
constraint forall(r in Rounds, p in Players) (
  score_per_round_per_player[r,p] = 
  
  sum(a in Artists) (
    visible_count_per_round_per_artist_per_player[r,p,a] * ranking_score_per_artist_per_round[r,a]
  )
);

% 2. For the whole game
constraint forall(p in Players) (
  score_per_player[p] = sum(r in Rounds) (score_per_round_per_player[r,p])
);
