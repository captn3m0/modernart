% Sanity check
constraint forall (a in Artists, r in Rounds) (
  cards_per_artist_per_round[r,a]>=0
);
% So they don't go negative
constraint forall (a in Artists, r in Rounds, p in Players) (
  visible_count_per_round_per_artist_per_player[r,p, a]>=0
);

% Score sanity per round
constraint forall (a in Artists, r in Rounds) (
  ranking_score_per_artist_per_round[r,a] >=0
);

% Round 1 Player 1
constraint first_player[Round1] = Nemo;