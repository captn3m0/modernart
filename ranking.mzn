% How much score was made by each artist in each round by just RANKING
array[Rounds,Artists] of var 0..3: ranking_score_per_artist_per_round;

% Winning artists for each round (just-by-ranking)
array[Rounds,1..card(Artists)] of var Artists: sorted_artists_per_round;

% Is any artist ranked in this round or not
array[Rounds,Artists] of var bool: IsArtistRanked;

% Decide the top artists by picking the cards per artist for that round, and sorting them
constraint forall(r in Rounds)(
  row(sorted_artists_per_round,r)= reverse(arg_sort(row(CardsForArtist, r)))
);

% Top three artists get ranking score in each round as 3,2,1 others get 0
constraint forall(r in Rounds) (ranking_score_per_artist_per_round[r, row(sorted_artists_per_round,r)[1]] = 3);
constraint forall(r in Rounds) (ranking_score_per_artist_per_round[r, row(sorted_artists_per_round,r)[2]] = 2);
constraint forall(r in Rounds) (ranking_score_per_artist_per_round[r, row(sorted_artists_per_round,r)[3]] = 1);
constraint forall(r in Rounds) (ranking_score_per_artist_per_round[r, row(sorted_artists_per_round,r)[4]] = 0);
constraint forall(r in Rounds) (ranking_score_per_artist_per_round[r, row(sorted_artists_per_round,r)[5]] = 0);

constraint forall(r in Rounds, a in Artists) (
   IsArtistRanked[r,a] = if ranking_score_per_artist_per_round[r,a] > 0 then true else false endif
);